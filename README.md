## Chat-API

An API for running a chat microservice. Take home assignment for Grailed interview. See [spec](spec.md) .

### Tech Stack

This is a Rails 5.1 app configured in API mode and using ruby 2.4.1. The database is postgres.

RSpec is used for the test suite. Test coverage with SimpleCov (100%). Code style enforced with rubocop.

Active Model Serializers is used for serializing json.

### Architecture

The application uses three main model classes: `User`, `Conversation` and `Message`.

#### User
Mostly a dummy class as authentication was outside the scope of the spec. I also left authorization out of the spec. Ideally a user should only be able to create a message in a conversation in which they are a participant. It would be pretty easy to add a basic validation or guard against this, but the better approach is to roll a scalable authorization scheme.

#### Conversation
A `Conversation` represents 2 or more users who can exchange messages in a thread.

The spec called for users to be able to message one another. In an attempt to be future proof, I designed the `Conversation` model to allow 2 or more users to particpate in a conversation such that the service could support a group chat.

Users belong to a conversation via the `ConversationUser` model and join table. While this could have been setup with a `has_and_belongs_to_many` relationship, by using a `has_many, through` relationship, we can later work with this class directly.

This might be useful if we wanted to allow a user to mute a conversation, or if we introduced business rules that some users could only view a conversation yet not participate.

A `Conversation` also `has_many` messages.

#### Message

A `Message` represents an utterance that a specific user makes in the context of a `Conversation`. It `belongs_to` a user, and simply includes some content and timestamps. In the future we might extend the functionality of the class to support things like image based messages.

### Tests
I wrote unit and request specs to ensure the API functions properly. Controller specs feel like overkill here (and are going out of vogue a bit I think), and with a stateless API, feature specs don't really make much sense. In a production microservice, I'd hope to be able to test the API as part of the build process from outside the API itself, using something like Postman with Newman. Ultimately there are probably other microservices that complement the chat API that would also be covered in this higher level QA.

I prefer to write specs in a way that makes the rspec documentation formatter read well (`bundle exec rspec -f d`).

Example output:
```
Message
  ::new_in_conversation
    when provided a conversation_id, a sender, and content
      returns a Message
      that is not persisted
      including the expected content
      from the expected sender
```

### Endpoints
I don't think documentation was really part of the scope, but these are the 4 endpoints provided by the API -

#### List Conversations

`GET '/conversations'`

Returns a list of all of the current user's conversations. This could be improved through pagination.

```json
{
    "conversations": [
        {
            "id": "0adc8649-ff54-47b0-8f32-c34e7d58ea93",
            "created_at": "2017-11-15T22:43:35.047Z",
            "updated_at": "2017-11-15T22:43:35.047Z"
        }
    ]
}
```

#### Create Conversation

`POST '/conversations'`

Creates a conversation on behalf of the current user.

Request body:

```json
{
	"conversation": {
		"recipients":  [
			"cc97c916-5ab6-41ea-a552-6444fadaa5ac",
		]
	}
}
```

Response:
```json
{
    "conversation": {
        "id": "12feb1bd-0bdd-4b51-953c-54bb43668253",
        "created_at": "2017-11-16T22:27:50.910Z",
        "updated_at": "2017-11-16T22:27:50.910Z",
        "participants": [
            {
                "id": "280553ec-0035-40a6-a4b8-6d3cdc00ab26",
                "username": "sam",
                "avatar_url": null
            },
            {
                "id": "cc97c916-5ab6-41ea-a552-6444fadaa5ac",
                "username": "bob",
                "avatar_url": null
            }
        ],
        "messages": []
    }
}
```

### Get Conversation
`GET '/conversation/:id'`

Fetches a conversation and it's 50 most recent messages. Provides pagination in order to get older messages, passed as a `page` parameter to the same URL on subsequent requests, i.e. `/conversations/:id?page=2`.

Response:

```json
{
    "conversation": {
        "id": "0adc8649-ff54-47b0-8f32-c34e7d58ea93",
        "created_at": "2017-11-15T22:43:35.047Z",
        "updated_at": "2017-11-15T22:43:35.047Z",
        "messages": [
            {
                "id": "bbfba6a1-f501-4f49-b1a6-ad9a0b37719a",
                "content": "Just workin on the README",
                "user_id": "280553ec-0035-40a6-a4b8-6d3cdc00ab26",
                "created_at": "2017-11-16T22:37:58.918Z",
                "conversation_id": "0adc8649-ff54-47b0-8f32-c34e7d58ea93"
            },
            /*...truncated...*/
            {
                "id": "b9a62644-6b5b-441f-b820-9b2790efc191",
                "content": "What's up?",
                "user_id": "280553ec-0035-40a6-a4b8-6d3cdc00ab26",
                "created_at": "2017-11-16T22:37:38.302Z",
                "conversation_id": "0adc8649-ff54-47b0-8f32-c34e7d58ea93"
            },
            {
                "id": "fee7b768-a589-4836-bd61-c4d01ffed574",
                "content": "Hello friends!",
                "user_id": "280553ec-0035-40a6-a4b8-6d3cdc00ab26",
                "created_at": "2017-11-16T22:37:38.037Z",
                "conversation_id": "0adc8649-ff54-47b0-8f32-c34e7d58ea93"
            }
        ]
    },
    "meta": {
        "current_page": 1,
        "next_page": 2,
        "prev_page": null,
        "total_pages": 2,
        "total_count": 56
    }
}
```

#### Create Message

`POST '/messages'`

Creates a message belonging to a conversation on behalf of the current user.

In terms of the API design, this is maybe not super RESTful. I go back and forth on whether I might prefer this endpoint to live at `/conversations/:conversation_id/messages`.

I think that I prefer this way for now as it makes it a little easier on the client? I can pass in all of my params to the POST body, rather than pulling the convo ID out of say a JS object and putting it in the URL for the API call.

Request body:

```json
{
	"message": {
		"content":  "Hello friends!",
    "conversation_id": "0adc8649-ff54-47b0-8f32-c34e7d58ea93"
	}
}
```

Response:

```json
{
    "message": {
        "id": "18d2ea57-f487-4c4a-8186-df80ed1db983",
        "content": "Hello friends!",
        "user_id": "280553ec-0035-40a6-a4b8-6d3cdc00ab26",
        "created_at": "2017-11-16T22:32:35.785Z"
    }
}
```

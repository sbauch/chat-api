# frozen_string_literal: true

class EnablePgcryptoExtension < ActiveRecord::Migration[5.1]
  def change
    disable_extension "uuid-ossp"
    enable_extension "pgcrypto"
  end
end

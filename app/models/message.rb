# frozen_string_literal: true

class Message
  attr_accessor :text

  def initialize(text)
    self.text = text
  end

  def self.public_message
    new('This is a public message.')
  end

  def self.protected_message
    new('This is a protected message.')
  end

  def self.admin_message
    new('This is an admin message.')
  end
end

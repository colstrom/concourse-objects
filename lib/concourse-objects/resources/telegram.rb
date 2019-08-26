# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Telegram < Resource
      RESOURCE_NAME     = "telegram"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "carlo-colombo"
      GITHUB_REPOSITORY = "carlo-colombo/telegram-resource"
      GITHUB_VERSION    = "v0.4.0-dev.5"

      class Source < Object
        required :telegram_key, write: AsString
        optional :filter,       write: AsString
        optional :flags,        write: AsString
      end

      class OutParams < Object
        optional :text, write: AsString
        optional :chat_id, write: AsString
        optional :message, write: AsString

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (message, (chat_id, text))" unless (this.message? or (this.chat_id? and this.text?))
            
            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "telegram"))
      end
    end
  end
end

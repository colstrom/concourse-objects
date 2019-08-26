# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class RocketChatNotification < Resource
      RESOURCE_NAME     = "rocketchat-notification"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "michaellihs"
      GITHUB_REPOSITORY = "michaellihs/rocketchat-notification-resource"
      GITHUB_VERSION    = "1.0.3"

      class Source < Object
        DEFAULT_ALIAS = "Concourse"
        DEFAULT_DEBUG = false

        required :url,      write: AsString
        required :user,     write: AsString
        required :password, write: AsString

        optional :channel,  write: AsString
        optional :alias,    write: AsString,  default: proc { DEFAULT_ALIAS }
        optional :debug,    write: AsBoolean, default: proc { DEFAULT_DEBUG }
      end

      class OutParams < Object
        DEFAULT_ALIAS = "Concourse"

        required :channel, write: AsString
        required :message, write: AsString

        optional :alias,   write: AsString, default: proc { DEFAULT_ALIAS }
      end

        optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "rocketchat-notification"))
      end
    end
  end
end

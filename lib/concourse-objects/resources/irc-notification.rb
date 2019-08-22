# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class IRCNotification < Resource
      RESOURCE_NAME     = "irc-notification"
      GITHUB_OWNER      = "flavorjones"
      GITHUB_REPOSITORY = "flavorjones/irc-notification-resource"
      GITHUB_VERSION    = "v1.2.0"

      class Source < Object
        DEFAULT_USETLS = true
        DEFAULT_JOIN   = false
        DEFAULT_DEBUG  = false

        required :server,   write: AsString
        required :port,     write: AsInteger
        required :channel,  write: AsString
        required :user,     write: AsString
        required :password, write: AsString

        optional :usetls, write: AsBoolean, default: proc { DEFAULT_USETLS }
        optional :join,   write: AsBoolean, default: proc { DEFAULT_JOIN }
        optional :debug,  write: AsBoolean, default: proc { DEFAULT_DEBUG }
      end

      class OutParams < Object
        required :message, write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "irc-notification"))
      end
    end
  end
end

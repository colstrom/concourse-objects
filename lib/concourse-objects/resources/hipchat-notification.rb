# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class HipChatNotification < Resource
      RESOURCE_NAME     = "hipchat-notification"
      GITHUB_OWNER      = "cloudfoundry-community"
      GITHUB_REPOSITORY = "cloudfoundry-community/hipchat-notification-resource"
      GITHUB_VERSION    = "v0.0.4"

      class Source < Object
        required :hipchat_server_url, write: AsString
        required :token,              write: AsString

        optional :room_id,            write: AsString
      end

      class OutParams < Object
        class Message < Object
          required :template, write: AsString
          required :params,   write: AsHashOf.(:to_s, :to_s)

          def self.call(object)
            case object
            when String then new(template: object, params: {})
            else super(object)
            end
          end
        end

        DEFAULT_COLOR      = "yellow"
        DEFAULT_FORMAT     = "html"
        DEFAULT_NOTIFY     = 0

        ACCEPTABLE_COLORS  = ["yellow", "red", "green", "purple", "gray", "random"]
        ACCEPTABLE_FORMATS = ["html", "text"]

        AsBooleanInteger   = proc { |source| (source == 0) ? false : (AsBoolean.(source) ? 1 : 0) }
        ColorIsAcceptable  = proc { |_, color|  ACCEPTABLE_COLORS.include?(color)  }
        FormatIsAcceptable = proc { |_, format| ACCEPTABLE_FORMATS.include?(color) }

        required :from,    write: AsString
        required :message, write: Message

        optional :color,   write: AsString,         default: proc { DEFAULT_COLOR  }, guard: ColorIsAcceptable
        optional :format,  write: AsString,         default: proc { DEFAULT_FORMAT }, guard: FormatIsAcceptable
        optional :notify,  write: AsBooleanInteger, default: proc { DEFAULT_NOTIFY }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "hipchat-notification"))
      end
    end
  end
end

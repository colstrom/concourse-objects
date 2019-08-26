# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Bender < Resource
      RESOURCE_NAME     = "bender"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "ahelal"
      GITHUB_REPOSITORY = "ahelal/bender"
      GITHUB_VERSION    = "v0.0.10"

      class Source < Object
        DEFAULT_AS_USER           = true
        DEFAULT_BOT_NAME          = "bender"
        DEFAULT_MENTION           = true
        DEFAULT_SLACK_UNREAD      = false
        DEFAULT_TEMPLATE_FILENAME = "template_file.txt"

        NotAsUser = proc { |source| source.as_user }

        required :channel,           write: AsString
        required :slack_token,       write: AsString

        optional :bot_icon_emoji,    write: AsString,                                              guard: NotAsUser
        optional :bot_icon_url,      write: AsString,                                              guard: NotAsUser
        optional :bot_name,          write: AsString,  default: proc { DEFAULT_BOT_NAME },         guard: NotAsUser
        optional :mention,           write: AsBoolean, default: proc { DEFAULT_MENTION },          guard: NotAsUser
        optional :as_user,           write: AsBoolean, default: proc { DEFAULT_AS_USER }
        optional :slack_unread,      write: AsBoolean, default: proc { DEFAULT_SLACK_UNREAD }
        optional :template_filename, write: AsString,  default: proc { DEFAULT_TEMPLATE_FILENAME }
        optional :template,          write: AsString
        optional :grammar,           write: AsString

        def initialize(options = {})
          super(options)
          super(options) do |this, options|
            yield this, options if block_given?
          end
        end
      end

      class OutParams < Object
        DEFAULT_REPLY_THREAD = false

        required :path,              write: AsString

        optional :reply,             write: AsString
        optional :reply_attachments, write: AsString
        optional :reply_thread,      write: AsBoolean, default: proc { DEFAULT_REPLY_THREAD }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "bender"))
      end
    end
  end
end

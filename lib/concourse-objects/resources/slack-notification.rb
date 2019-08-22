# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class SlackNotification < Resource
      RESOURCE_NAME     = "slack-notification"
      GITHUB_OWNER      = "cloudfoundry-community"
      GITHUB_REPOSITORY = "cloudfoundry-community/slack-notification-resource"
      GITHUB_VERSION    = "v1.5.0"

      class Source < Object
        DEFAULT_PROXY_HTTP_TUNNEL = false
        DEFAULT_DISABLE           = false
        DEFAULT_INSECURE          = false

        required :url,                write: AsString

        optional :proxy,              write: AsString
        optional :ca_certs,           write: AsArrayOf.(:to_s), default: EmptyArray
        optional :proxy_https_tunnel, write: AsBoolean,         default: proc { DEFAULT_PROXY_HTTP_TUNNEL}
        optional :disable,            write: AsBoolean,         default: proc { DEFAULT_DISABLE }
        optional :insecure,           write: AsBoolean
      end

      class OutParams < Object
        class Attachment < Object
          class Field < Object
            DEFAULT_SHORT = false

            optional :title, write: AsString
            optional :value, write: AsString
            optional :short, write: AsBoolean, default: proc { DEFAULT_SHORT }
          end

          optional :fallback,    write: AsString
          optional :color,       write: AsString
          optional :pretext,     write: AsString
          optional :author_name, write: AsString
          optional :author_link, write: AsString
          optional :author_icon, write: AsString
          optional :title,       write: AsString
          optional :title_link,  write: AsString
          optional :image_url,   write: AsString
          optional :thumb_url,   write: AsString
          optional :footer,      write: AsString
          optional :footer_icon, write: AsString
          optional :ts,          write: AsInteger
          optional :fields,      write: AsArrayOf.(Field), default: EmptyArray
        end

        DEFAULT_SILENT        = false
        DEFAULT_ALWAYS_NOTIFY = false

        optional :text,             write: AsString
        optional :text_file,        write: AsString
        optional :attachments_file, write: AsString
        optional :attachments,      write: AsArrayOf.(Attachment), default: EmptyArray

        optional :silent,           write: AsBoolean,              default: proc { DEFAULT_SILENT }
        optional :always_notify,    write: AsBoolean,              default: proc { DEFAULT_ALWAYS_NOTIFY }
        optional :channel,          write: AsString
        optional :channel_file,     write: AsString
        optional :env_file,         write: AsString
        optional :username,         write: AsString
        optional :icon_url,         write: AsString
        optional :icon_emoji,       write: AsString

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (text, text_file, attachments, attachments_file)" unless (this.text? or this.text_file? or this.attachments? or this.attachments_file?)

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "slack-notification"))
      end
    end
  end
end

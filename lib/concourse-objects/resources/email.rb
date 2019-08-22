# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Email < Resource
      RESOURCE_NAME     = "email"
      GITHUB_OWNER      = "pivotal-cf"
      GITHUB_REPOSITORY = "pivotal-cf/email-resource"
      GITHUB_VERSION    = "v1.0.17"

      class Source < Object
        class SMTP < Object
          DEFAULT_ANONYMOUS           = false
          DEFAULT_SKIP_SSL_VALIDATION = false
          DEFAULT_HOST_ORIGIN         = "localhost"

          required :host, write: AsString
          required :port, write: AsString

          optional :username,            write: AsString
          optional :password,            write: AsString
          optional :ca_cert,             write: AsString
          optional :anonymous,           write: AsBoolean, default: proc { DEFAULT_ANONYMOUS }
          optional :skip_ssl_validation, write: AsBoolean, default: proc { DEFAULT_SKIP_SSL_VALIDATION }
          optional :login_auth,          write: AsBoolean, default: proc { DEFAULT_LOGIN_AUTH }
          optional :host_origin,         write: AsString,  default: proc { DEFAULT_HOST_ORIGIN }

          def initialize(options = {})
            super(options) do |this, options|
              raise KeyError, "#{self.class.inspect} requires (username, password) unless (anonymous) is true" unless this.anonymous

              yield this, options if block_given?
            end
          end
        end

        required :from, write: AsString

        required :to,   write: AsArrayOf.(:to_s), default: EmptyArray
        optional :cc,   write: AsArrayOf.(:to_s), default: EmptyArray
        optional :bcc,  write: AsArrayOf.(:to_s), default: EmptyArray
      end

      class OutParams < Object
        DEFAULT_SEND_EMPTY_BODY = false
        DEFAULT_DEBUG           = false

        optional :headers,          write: AsString
        optional :subject,          write: AsString
        optional :subject_text,     write: AsString
        optional :body,             write: AsString
        optional :body_text,        write: AsString
        optional :to,               write: AsString
        optional :cc,               write: AsString
        optional :bcc,              write: AsString
        optional :attachment_globs, write: AsArrayOf.(:to_s)
        optional :send_empty_body,  write: AsBoolean,        default: proc { DEFAULT_SEND_EMPTY_BODY }
        optional :debug,            write: AsBoolean,        default: proc { DEFAULT_DEBUG }

        def initialize(pptions = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (subject, subject_text)" unless (this.subject? or this.subject_text?)
            raise KeyError, "#{self.class.inspect} requires on of (body, body_text)" unless (this.body? or this.body_text?)

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "email"))
      end
    end
  end
end

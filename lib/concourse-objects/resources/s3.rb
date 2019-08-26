# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class S3 < Resource
      RESOURCE_NAME     = "s3"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/s3-resource"
      GITHUB_VERSION    = "v1.0.3"

      class Source < Object
        DEFAULT_SKIP_SSL_VERIFICATION = false
        DEFAULT_DISABLE_MULTIPART     = false
        DEFAULT_DISABLE_SSL           = false
        DEFAULT_SKIP_DOWNLOAD         = false
        DEFAULT_USE_V2_SIGNING        = false
        DEFAULT_PRIVATE               = false
        DEFAULT_REGION_NAME           = "us-east-1"

        HasRegexp        = proc { |source| source.regexp? }
        HasVersionedFile = proc { |source| source.versioned_file?}
        HasInitialState  = proc { |source| source.regexp? or source.versioned_file? }

        required :bucket,                 write: AsString

        optional :private,                write: AsBoolean, default: proc { DEFAULT_PRIVATE }
        optional :disable_ssl,            write: AsBoolean, default: proc { DEFAULT_DISABLE_SSL }
        optional :skip_ssl_verification,  write: AsBoolean, default: proc { DEFAULT_SKIP_SSL_VERIFICATION }
        optional :skip_download,          write: AsBoolean, default: proc { DEFAULT_SKIP_DOWNLOAD }
        optional :use_v2_signing,         write: AsBoolean, default: proc { DEFAULT_USE_V2_SIGNING }
        optional :disable_multipart,      write: AsBoolean, default: proc { DEFAULT_DISABLE_MULTIPART }
        optional :region_name,            write: AsString,  default: proc { DEFAULT_REGION_NAME }
        optional :initial_path,           write: AsString,                                                  guard: HasRegexp
        optional :initial_version,        write: AsString,                                                  guard: HasVersionedFile
        optional :initial_content_text,   write: AsString,                                                  guard: HasInitialState
        optional :initial_content_binary, write: AsString,                                                  guard: HasInitialState
        optional :regexp,                 write: AsString
        optional :versioned_file,         write: AsString
        optional :access_key_id,          write: AsString
        optional :secret_access_key,      write: AsString
        optional :session_token,          write: AsString
        optional :cloudfront_url,         write: AsString
        optional :endpoint,               write: AsString
        optional :server_side_encryption, write: AsString
        optional :sse_kms_key_id,         write: AsString

        def initialize(options = {})
          super(options)
          super(options) do |this, options|
            raise KeyError, "expected one of (regexp, versioned_file), got both" if (this.regexp? and this.versioned_file?)

            yield this, options if block_given?
          end
        end
      end

      class InParams < Object
        DEFAULT_SKIP_DOWNLOAD = false
        DEFAULT_UNPACK        = true

        optional :skip_download, write: AsBoolean, default: proc { DEFAULT_SKIP_DOWNLOAD }
        optional :unpack,        write: AsBoolean, default: proc { DEFAULT_UNPACK }
      end

      class OutParams < Object
        required :file, write: AsString

        optional :acl,          write: AsString
        optional :content_type, write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "s3")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end

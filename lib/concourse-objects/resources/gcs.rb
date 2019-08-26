# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class GCS < Resource
      RESOURCE_NAME     = "gcs"
      GITHUB_OWNER      = "frodenas"
      GITHUB_REPOSITORY = "frodenas/gcs-resource"
      GITHUB_VERSION    = "v0.5.1"

      class Source < Object
        required :bucket,                 write: AsString
        required :json_key,               write: AsString

        optional :regexp,                 write: AsString
        optional :versioned_file,         write: AsString
        optional :initial_path,           write: AsString, guard: proc { |source| source.regexp? }
        optional :initial_version,        write: AsString, guard: proc { |source| source.versioned_file? }
        optional :initial_text,           write: AsString
        optional :initial_content_binary, write: AsString

        def initialize(options = {})
          super(options)
          super(options) do |this, options|
            raise KeyError, "#{this.class.inspect} requires one of (regexp, versioned_file)" unless (this.regegxp? or this.versioned_file?)

            yield this, options if block_given?
          end
        end
      end

      class InParams < Object
        DEFAULT_SKIP_DOWNLOAD = false
        DEFAULT_UNPACK        = false

        optional :skip_download, write: AsBoolean, default: proc { DEFAULT_SKIP_DOWNLOAD }
        optional :unpack,        write: AsBoolean, default: proc { DEFAULT_UNPACK }
      end

      class OutParams < Object
        ACCEPTABLE_PREDEFINED_ACLS = ["authenticatedRead", "bucketOwnerFullControl", "bucketOwnerRead", "private", "projectPrivate", "publicRead", "publicReadWrite"]
        PredefinedACLIsAcceptable  = proc { |_, predefined_acl| ACCEPTABLE_PREDEFINED_ACLS.include?(predefined_acl) }

        required :file, write: AsString

        optional :predefined_acl, write: AsString, guard: PredefinedACLIsAcceptable
        optional :content_type,   write: AsString
        optional :cache_control,  write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "gcs"))
      end
    end
  end
end

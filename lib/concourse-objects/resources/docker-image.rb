# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class DockerImage < Resource
      RESOURCE_NAME     = "docker-image"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/docker-image-resource"
      GITHUB_VERSION    = "v1.3.1"

      class Source < Object
        class CACert < Object
          required :domain, write: AsString
          required :cert,   write: AsString
        end

        class ClientCert < Object
          required :domain, write: AsString
          required :cert,   write: AsString
          required :key,    write: AsString
        end

        DEFAULT_TAG = "latest"

        required :repository,               write: AsString

        optional :ca_certs,                 write: AsArrayOf.(CACert),     default: EmptyArray
        optional :client_certs,             write: AsArrayOf.(ClientCert), default: EmptyArray
        optional :insecure_registries,      write: AsArrayOf.(:to_s),      default: EmptyArray
        optional :tag,                      write: AsString,               default: proc { DEFAULT_TAG }
        optional :username,                 write: AsString
        optional :password,                 write: AsString
        optional :aws_access_key_id,        write: AsString
        optional :aws_secret_access_key,    write: AsString
        optional :aws_session_token,        write: AsString
        optional :registry_mirror,          write: AsString
        optional :max_concurrent_downloads, write: AsInteger
        optional :max_concurrent_uploads,   write: AsInteger
      end

      class InParams < Object
        DEFAULT_SAVE          = false
        DEFAULT_ROOTFS        = false
        DEFAULT_SKIP_DOWNLOAD = false

        optional :save,          write: AsBoolean, default: proc { DEFAULT_SAVE }
        optional :rootfs,        write: AsBoolean, default: proc { DEFAULT_ROOTFS }
        optional :skip_download, write: AsBoolean, default: proc { DEFAULT_SKIP_DOWNLOAD }
      end

      class OutParams < Object
        DEFAULT_CACHE         = false
        DEFAULT_TAG_AS_LATEST = false
        DEFAULT_LOAD_TAG      = "latest"
        DEFAULT_PULL_TAG      = "latest"

        optional :build_args,      write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :labels,          write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :cache_from,      write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :load_bases,      write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :cache,           write: AsBoolean,               default: proc { DEFAULT_CACHE }
        optional :tag_as_latest,   write: AsBoolean,               default: proc { DEFAULT_TAG_AS_LATEST }
        optional :load_tag,        write: AsString,                default: proc { DEFAULT_LOAD_TAG }
        optional :pull_tag,        write: AsString,                default: proc { DEFAULT_PULL_TAG }
        optional :additional_tags, write: AsString
        optional :build,           write: AsString
        optional :build_args_file, write: AsString
        optional :dockerfile,      write: AsString
        optional :import_file,     write: AsString
        optional :labels_file,     write: AsString
        optional :load,            write: AsString
        optional :load_base,       write: AsString
        optional :load_file,       write: AsString
        optional :load_repository, write: AsString
        optional :pull_repository, write: AsString
        optional :tag,             write: AsString
        optional :tag_file,        write: AsString
        optional :tag_prefix,      write: AsString
        optional :target_name,     write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "docker-image")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end

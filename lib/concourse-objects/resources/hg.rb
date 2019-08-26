# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Hg < Resource
      RESOURCE_NAME     = "hg"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/hg-resource"
      GITHUB_VERSION    = "v1.0.2"

      class Source < Object
        DEFAULT_BRANCH                = "default"
        DEFAULT_SKIP_SSL_VERIFICATION = false

        required :uri,    write: AsString

        optional :private_key,           write: AsString
        optional :tag_filter,            write: AsString
        optional :revset_filter,         write: AsString
        optional :branch,                write: AsString,          default: proc { DEFAULT_BRANCH }
        optional :skip_ssl_verification, write: AsBoolean,         default: proc { DEFAULT_SKIP_SSL_VERIFICATION }
        optional :paths,                 write: AsArrayOf.(:to_s), default: EmptyArray
        optional :ignore_paths,          write: AsArrayOf.(:to_s), default: EmptyArray
      end

      class OutParams < Object
        DEFAULT_REBASE = false

        required :repository, write: AsString

        optional :tag_prefix, write: AsString
        optional :tag,        write: AsString,                                   guard: proc { |params| params.rebase? }
        optional :rebase,     write: AsBoolean, default: proc { DEFAULT_REBASE }

        def initialize(options = {})
          super(options)
          super(options) do |this, options|
            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "hg")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end

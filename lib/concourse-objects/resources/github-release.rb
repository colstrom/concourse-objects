# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class GitHubRelease < Resource
      RESOURCE_NAME     = "github-release"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/github-release-resource"
      GITHUB_VERSION    = "v1.1.1"

      class Source < Object
        DEFAULT_INSECURE     = false
        DEFAULT_RELEASE      = true
        DEFAULT_PRE_RELEASE  = false
        DEFAULT_DRAFTS       = false
        DEFAULT_TAG_FILTER   = "v?([^v].*)"
        DEFAULT_ORDER_BY     = "version"

        ACCEPTABLE_ORDER_BYS = ["version", "time"]

        OrderByIsAcceptable  = proc { |_, order_by| ACCEPTABLE_ORDER_BYS.include?(order_by) }

        required :owner,              write: AsString
        required :repository,         write: AsString

        optional :access_token,       write: AsString
        optional :github_api_url,     write: AsString
        optional :github_uploads_url, write: AsString
        optional :order_by,           write: AsString,  default: proc { DEFAULT_ORDER_BY },   guard: OrderByIsAcceptable
        optional :tag_filter,         write: AsString,  default: proc { DEFAULT_TAG_FILTER }
        optional :insecure,           write: AsBoolean, default: proc { DEFAULT_INSECURE }
        optional :release,            write: AsBoolean, default: proc { DEFAULT_RELEASE }
        optional :pre_release,        write: AsBoolean, default: proc { DEFAULT_PRE_RELEASE }
        optional :drafts,             write: AsBoolean, default: proc { DEFAULT_DRAFTS }

        def initialize(options = {})
          options.transform_keys(&:to_sym).then do |options|
            unless options.key?(:owner)
              options.store(:owner, options.fetch(:user)) if options.key?(:user)
            end

            super(options) do |this, options|
              yield this, options if block_given?
            end
          end
        end   
      end

      class InParams < Object
        DEFAULT_INCLUDE_SOURCE_TARBALL = false
        DEFAULT_INCLUDE_SOURCE_ZIP     = false

        optional :include_source_tarball, write: AsBoolean, default: proc { DEFAULT_INCLUDE_SOURCE_TARBALL }
        optional :include_source_zip,     write: AsBoolean, default: proc { DEFAULT_INCLUDE_SOURCE_ZIP }
        optional :globs,                  write: AsArrayOf.(:to_s)
      end

      class OutParams < Object
        required :name,       write: AsString
        required :type,       write: AsString

        optional :tag_prefix, write: AsString
        optional :commitish,  write: AsString
        optional :body,       write: AsString
        optional :globs,      write: AsArrayOf.(:to_s)
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "github-release")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end

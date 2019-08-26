# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Gerrit < Resource
      RESOURCE_NAME     = "gerrit"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "google"
      GITHUB_REPOSITORY = "google/concourse-resources"
      GITHUB_VERSION    = "0.2.2"

      class Source < Object
        DEFAULT_DIGEST_AUTH = false
        DEFAULT_QUERY       = "status:open"

        required :uri,         write: AsString

        optional :digest_auth, write: AsBoolean, default: proc { DEFAULT_DIGEST_AUTH }
        optional :query,       write: AsString,  default: proc { DEFAULT_QUERY }
        optional :cookies,     write: AsString
        optional :password,    write: AsString
        optional :username,    write: AsString
      end

      class InParams < Object
        DEFAULT_FETCH_PROTOCOL = "http"

        optional :fetch_protocol, write: AsString, default: proc { DEFAULT_FETCH_PROTOCOL }
        optional :fetch_url,      write: AsString
      end

      class OutParams < Object
        required :repository,   write: AsString

        optional :message,      write: AsString
        optional :message_file, write: AsString
        optional :labels,       write: AsHash,  default: EmptyHash
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "gerrit"))
      end
    end
  end
end

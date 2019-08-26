# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Swift < Resource
      RESOURCE_NAME     = "swift"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "sapcc"
      GITHUB_REPOSITORY = "sapcc/swift-resource"
      GITHUB_VERSION    = "v1.3.0"

      class Source < Object
        DEFAULT_DISABLE_TLS_VERIFY = false

        required :auth_url,           write: AsString
        required :username,           write: AsString
        required :api_key,            write: AsString
        required :domain,             write: AsString
        required :tenant_id,          write: AsString
        required :container,          write: AsString
        required :regex,              write: AsString

        optional :disable_tls_verify, write: AsBoolean, default: proc { DEFAULT_DISABLE_TLS_VERIFY }
      end

      class OutParams < Object
        required :from,              write: AsString

        optional :segment_container, write: AsString
        optional :segment_size,      write: AsInteger
        optional :delete_after,      write: AsInteger
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "swift"))
      end
    end
  end
end

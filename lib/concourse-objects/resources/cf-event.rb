# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class CFEvent < Resource
      RESOURCE_NAME     = "cf-event"
      GITHUB_OWNER      = "mevansam"
      GITHUB_REPOSITORY = "mevansam/cf-event-resource-type"
      GITHUB_VERSION    = "0.9.3"

      class Source < Object
        DEFAULT_SKIP_SSL_VALIDATION = false
        DEFAULT_DEBUG               = false
        DEFAULT_TRACE               = false

        required :api,                   write: AsString
        required :user,                  write: AsString
        required :password,              write: AsString
        required :org,                   write: AsString
        required :space,                 write: AsString

        optional :apps,                  write: AsArrayOf.(:to_s), default: EmptyArray
        optional :"skip-ssl-validation", write: AsBoolean,         default: proc { DEFAULT_SKIP_SSL_VALIDATION }
        optional :debug,                 write: AsBoolean,         default: proc { DEFAULT_DEBUG }
        optional :trace,                 write: AsBoolean,         default: proc { DEFAULT_TRACE }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "cf-event"))
      end
    end
  end
end

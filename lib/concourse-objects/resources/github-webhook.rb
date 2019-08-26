# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class GitHubWebhook < Resource
      RESOURCE_NAME     = "github-webhook"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "homedepot"
      GITHUB_REPOSITORY = "homedepot/github-webhook-resource"
      GITHUB_VERSION    = "v1.1.1"

      class Source < Object
        required :github_api,   write: AsString
        required :github_token, write: AsString
      end

      class OutParams < Object
        DEFAULT_EVENTS        = ["push"].freeze
        ACCEPTABLE_OPERATIONS = ["create", "delete"].freeze
        OperationIsAcceptable = proc { |_, operation| ACCEPTABLE_OPERATIONS.include?(operation) }

        required :org,           write: AsString
        required :repo,          write: AsString
        required :resource_name, write: AsString
        required :webhook_token, write: AsString
        required :operation,     write: AsString,                                           guard: OperationIsAcceptable
        
        optional :events,        write: AsArrayOf.(:to_s), default: proc { DEFAULT_EVENTS }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "github-webhook"))
      end
    end
  end
end

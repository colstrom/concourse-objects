# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class GitHubStatus < Resource
      RESOURCE_NAME     = "github-status"
      GITHUB_OWNER      = "dpb587"
      GITHUB_REPOSITORY = "dpb587/github-status-resource"
      GITHUB_VERSION    = "v2.1.0"

      class Source < Object
        DEFAULT_BRANCH                = "master"
        DEFAULT_CONTEXT               = "default"
        DEFAULT_ENDPOINT              = "https://api.github.com"
        DEFAULT_SKIP_SSL_VERIFICATION = false

        required :repository,            write: AsString
        required :access_token,          write: AsString

        optional :branch,                write: AsString,  default: proc { DEFAULT_BRANCH }
        optional :context,               write: AsString,  default: proc { DEFAULT_CONTEXT }
        optional :endpoint,              write: AsString,  default: proc { DEFAULT_ENDPOINT }
        optional :skip_ssl_verification, write: AsBoolean, default: proc { DEFAULT_SKIP_SSL_VERIFICATION }
      end

      class OutParams < Object
        ACCEPTABLE_STATES = ["pending", "success", "error", "failure"]
        StateIsAcceptable = proc { |_, state| ACCEPTABLE_STATES.include?(state) }

        required :commit,           write: AsString
        required :state,            write: AsString, guard: StateIsAcceptable

        optional :description,      write: AsString
        optional :description_path, write: AsString
        optional :target_url,       write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "github-status"))
      end
    end
  end
end

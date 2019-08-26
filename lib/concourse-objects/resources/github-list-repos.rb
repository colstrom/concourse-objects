# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class GitHubListRepos < Resource
      RESOURCE_NAME     = "github-list-repos"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "coralogix"
      GITHUB_REPOSITORY = "coralogix/eng-concourse-github-list-repos-resource"
      GITHUB_VERSION    = "v0.3.1"

      class Source < Object
        required :"auth-token",  write: AsString
        required :org,           write: AsString

        optional :team,          write: AsString
        optional :include_regex, write: AsString
        optional :exclude_regex, write: AsString
        optional :exclude,       write: AsArrayOf.(:to_s), default: EmptyArray
      end

      class InParams < Object
        DEFAULT_OUTPUT_FORMAT = "txt"
        ACCEPTABLE_OUTPUT_FORMATS = ["txt", "json"]
        OutputFormatIsAcceptable  = proc { |_, output_format| ACCEPTABLE_OUTPUT_FORMATS.include?(output_format) }

        optional :output_format, write: AsString, default: proc { DEFAULT_OUTPUT_FORMAT }, guard: OutputFormatIsAcceptable
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "github-list-repos"))
      end
    end
  end
end

# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class GitHubPR < Resource
      RESOURCE_NAME     = "github-pr"
      GITHUB_OWNER      = "telia-oss"
      GITHUB_REPOSITORY = "telia-oss/github-pr-resource"
      GITHUB_VERSION    = "v0.18.0"

      class Source < Object
        required :repository,                write: AsString
        required :access_token,              write: AsString

        optional :v3_endpoint,               write: AsString
        optional :v4_endpoint,               write: AsString
        optional :paths,                     write: AsArrayOf.(:to_s)
        optional :ignore_paths,              write: AsArrayOf.(:to_s)
        optional :disable_ci_skip,           write: AsBoolean
        optional :skip_ssl_verification,     write: AsBoolean
        optional :disable_forks,             write: AsBoolean
        optional :required_review_approvals, write: AsInteger
        optional :git_crypt_key,             write: AsString
        optional :base_branch,               write: AsString
        optional :labels,                    write: AsArrayOf.(:to_s)
      end

      class InParams < Object
        DEFAULT_INTEGRATION_TOOL     = "merge"
        ACCEPTABLE_INTEGRATION_TOOLS = ["merge", "rebase", "checkout"]
        IntegrationToolIsAcceptable  = proc { |_, integration_tool| ACCEPTABLE_INTEGRATION_TOOLS.include?(integration_tool) }

        optional :skip_download,      write: AsBoolean
        optional :list_changed_files, write: AsBoolean
        optional :git_depth,          write: AsInteger
        optional :integration_tool,   write: AsString, default: proc { DEFAULT_INTEGRATION_TOOL }, guard: IntegrationToolIsAcceptable
      end

      class OutParams < Object
        DEFAULT_BASE_CONTEXT = "concourse-ci"
        DEFAULT_CONTEXT      = "status"
        ACCEPTABLE_STATUSES = ["SUCCESS", "PENDING", "FAILURE", "ERROR"]
        StatusIsAcceptable = proc { |_, status| ACCEPTABLE_STATUSES.include?(status) }

        required :path,         write: AsString
        
        optional :status,       write: AsString,                                        guard: StatusIsAcceptable
        optional :base_context, write: AsString, default: proc { DEFAULT_BASE_CONTEXT }
        optional :context,      write: AsString, default: proc { DEFAULT_CONTEXT }
        optional :comment,      write: AsString
        optional :comment_file, write: AsString
        optional :description,  write: AsString
        optional :target_url,   write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "github-pr"))
      end
    end
  end
end

# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class NewRelicDeploy < Resource
      RESOURCE_NAME     = "newrelic-deploy"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "homedepot"
      GITHUB_REPOSITORY = "homedepot/newrelic-deploy-resource"
      GITHUB_VERSION    = "v1.0"

      class Source < Object
        required :api_key, write: AsString
        required :app_id,  write: AsString
      end

      class OutParams < Object
        required :json_file, write: AsString
        optional :user,      write: AsString
      end
      
      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "newrelic-deploy"))
      end
    end
  end
end

# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Grafana < Resource
      RESOURCE_NAME     = "grafana"
      GITHUB_OWNER      = "telia-oss"
      GITHUB_REPOSITORY = "telia-oss/grafana-resource"
      GITHUB_VERSION    = "v0.0.2"

      class Source < Object
        required :grafana_url,   write: AsString
        required :grafana_token, write: AsString
      end

      class OutParams < Object
        required :dashboard_id, write: AsString
        required :panels,       write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "grafana"))
      end
    end
  end
end

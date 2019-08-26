# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Time < Resource
      RESOURCE_NAME     = "time"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/time-resource"
      GITHUB_VERSION    = "v1.2.1"

      class Source < Object
        DEFAULT_LOCATION = "UTC"

        optional :interval, write: AsString
        optional :start,    write: AsString
        optional :stop,     write: AsString
        optional :location, write: AsString,          default: proc { DEFAULT_LOCATION }
        optional :days,     write: AsArrayOf.(:to_s), default: EmptyArray
      end
      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "time"))
      end
    end
  end
end

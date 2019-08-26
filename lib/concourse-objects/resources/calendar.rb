# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Calendar < Resource
      RESOURCE_NAME     = "calendar"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "henrytk"
      GITHUB_REPOSITORY = "henrytk/calendar-resource"
      GITHUB_VERSION    = "v1.1"

      class Source < Object
        required :provider,    write: AsString
        required :calendar_id, write: AsString
        required :event_name,  write: AsString
        required :credentials, write: AsString
      end

      class OutParams < Object
        optional :summary,     write: AsString
        optional :description, write: AsString
        optional :time_zone,   write: AsString
        optional :start_time,  write: AsString
        optional :end_time,    write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "calendar"))
      end
    end
  end
end

# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class DeployGate < Resource
      RESOURCE_NAME     = "deploygate"
      GITHUB_OWNER      = "YuukiARIA"
      GITHUB_REPOSITORY = "YuukiARIA/concourse-deploygate-resource"
      GITHUB_VERSION    = "v0.2.1"

      class Source < Object
        required :api_key, write: AsString
        required :owner,   write: AsString
      end

      class OutParams < Object
        required :file,              write: AsString

        optional :message,           write: AsString
        optional :message_file,      write: AsString
        optional :distribution_key,  write: AsString
        optional :distribution_name, write: AsString
        optional :release_note,      write: AsString
        optional :disable_notify,    write: AsBoolean
        optional :visibility,        write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "mock"))
      end
    end
  end
end

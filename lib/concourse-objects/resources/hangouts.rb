# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Hangouts < Resource
      RESOURCE_NAME     = "hangouts"
      GITHUB_OWNER      = "CloudInn"
      GITHUB_REPOSITORY = "CloudInn/concourse-hangouts-resource"
      GITHUB_VERSION    = "v0.3.2-rc.7"

      class Source < Object
        DEFAULT_POST_URL = true

        required :webhook_url, write: AsString

        optional :post_url,    write: AsBoolean, default: proc { DEFAULT_POST_URL }
      end

      class OutParams < Object
        optional :message,      write: AsString
        optional :message_file, write: AsString
        optional :post_url,     write: AsBoolean
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "hangouts"))
      end
    end
  end
end

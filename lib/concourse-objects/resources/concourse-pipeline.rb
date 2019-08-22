# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class ConcoursePipeline < Resource
      RESOURCE_NAME     = "concourse-pipeline"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/concourse-pipeline-resource"
      GITHUB_VERSION    = "v2.2.0"

      class Source < Object
        class Team < Object
          required :name, write: AsString

          optional :username, write: AsString
          optional :password, write: AsString
        end

        DEFAULT_TARGET   = ENV.fetch("ATC_EXTERNAL_URL") { nil }
        DEFAULT_INSECURE = false

        required :teams,    write: AsArrayOf.(Team)

        optional :target,   write: AsString,  default: proc { DEFAULT_TARGET }
        optional :insecure, write: AsBoolean, default: proc { DEFAULT_INSECURE }
      end

      class OutParams < Object
        class Pipeline < Object
          DEFAULT_UNPAUSED = false
          DEFAULT_EXPOSED  = false

          required :name,         write: AsString
          required :team,         write: AsString
          required :config_file,  write: AsString

          optional :vars_files,   write: AsArrayOf.(:to_s)
          optional :vars,         write: AsHashOf.(:to_s, :to_s)
          optional :unpaused,     write: AsBoolean,              default: proc { DEFAULT_UNPAUSED }
          optional :exposed,      write: AsBoolean,              default: proc { DEFAULT_EXPOSED }
        end

        optional :pipelines,      write: AsArrayOf.(Pipeline)
        optional :pipelines_file, write: AsString

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (pipelines, pipelines_file)." unless (this.pipelines? or this.pipelines_file?)

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "concourse-pipeline"))
      end
    end
  end
end

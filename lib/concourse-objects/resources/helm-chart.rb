# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class HelmChart < Resource
      RESOURCE_NAME     = "helm-chart"
      GITHUB_OWNER      = "linkyard"
      GITHUB_REPOSITORY = "linkyard/helm-chart-resource"
      GITHUB_VERSION    = "v0.1.0"

      class Source < Object
        class Repo < Object
          required :name,     write: AsString
          required :url,      write: AsString

          optional :username, write: AsString
          optional :password, write: AsString
        end

        required :chart, write: AsString

        optional :repos, write: AsArrayOf.(Repo), default: EmptyArray
      end

      class InParams < Object
        DEFAULT_UNTAR  = false
        DEFAULT_VERIFY = false

        optional :untardir, write: AsString
        optional :untar,    write: AsBoolean, default: proc { DEFAULT_UNTAR }
        optional :verify,   write: AsBoolean, default: proc { DEFAULT_VERIFY }
      end
      
      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "helm-chart"))
      end
    end
  end
end

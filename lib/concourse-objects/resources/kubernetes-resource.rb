# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class KubernetesResource < Resource
      RESOURCE_NAME     = "kubernetes"
      RESOURCE_LICENSE  = nil
      GITHUB_OWNER      = "jcderr"
      GITHUB_REPOSITORY = "jcderr/concourse-kubernetes-resource"
      GITHUB_VERSION    = "v1.1.1"

      class Source < Object
        ACCEPTABLE_RESOURCE_TYPES = ["deployment", "replicationController", "job"]
        ResourceTypeIsAcceptable  = proc { |_, resource_type| ACCEPTABLE_RESOURCE_TYPES.include?(resource_type) }

        required :cluster_url,    write: AsString
        required :namespace,      write: AsString
        required :resource_name,  write: AsString
        required :resource_type,  write: AsString, guard: ResourceTypeIsAcceptable

        optional :container_name, write: AsString, default: proc { |source| source.resource_name }
        optional :cluster_ca,     write: AsString
        optional :admin_key,      write: AsString
        optional :admin_cert,     write: AsString
      end

      class OutParams < Object
        required :image_name, write: AsString
        required :image_tag,  write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "kubernetes"))
      end
    end
  end
end

# frozen_string_literal: true

require_relative "resources/bosh-io-release"
require_relative "resources/bosh-io-stemcell"
require_relative "resources/cf"
require_relative "resources/docker-image"
require_relative "resources/git"
require_relative "resources/github-release"
require_relative "resources/hg"
require_relative "resources/pool"
require_relative "resources/registry-image"
require_relative "resources/s3"
require_relative "resources/semver"
require_relative "resources/time"

require_relative "resources/concourse-pipeline"
require_relative "resources/email"
require_relative "resources/github-list-repos"
require_relative "resources/github-pr"
require_relative "resources/github-webhook"
require_relative "resources/grafana"
require_relative "resources/helm"
module ConcourseObjects
  module Resources
    def self.resources
      constants(false).map do |constant|
        const_get(constant)
      end
    end

    def self.owned_resources
      resources.select do |resource|
        resource.const_defined?(:GITHUB_OWNER)
      end
    end

    def self.named_resources
      resources.select do |resource|
        resource.const_defined?(:RESOURCE_NAME)
      end
    end

    def self.find(name)
      named_resources.find do |resource|
        name === resource.const_get(:RESOURCE_NAME)
      end
    end

    def self.named(name)
      named_resources.select do |resource|
        name === resource.const_get(:RESOURCE_NAME)
      end
    end

    def self.owners
      resources.group_by do |resource|
        resource.const_get(:GITHUB_OWNER) if resource.const_defined?(:GITHUB_OWNER)
      end
    end

    def self.owned_by(owner)
      owned_resources.select do |resource|
        owner === resource.const_get(:GITHUB_OWNER)
      end
    end
  end
end

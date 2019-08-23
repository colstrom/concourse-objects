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

require_relative "resources/ansible-playbook"
require_relative "resources/artifactory"
require_relative "resources/artifactory-deb"
require_relative "resources/bender"
require_relative "resources/bosh-release"
require_relative "resources/concourse-pipeline"
require_relative "resources/docker-compose"
require_relative "resources/email"
require_relative "resources/fly"
require_relative "resources/gerrit"
require_relative "resources/github-list-repos"
require_relative "resources/github-pr"
require_relative "resources/github-status"
require_relative "resources/github-webhook"
require_relative "resources/grafana"
require_relative "resources/helm"
require_relative "resources/helm-chart"
require_relative "resources/hipchat-notification"
require_relative "resources/irc-notification"
require_relative "resources/keyval"
require_relative "resources/maven"
require_relative "resources/metadata"
require_relative "resources/mock"
require_relative "resources/newrelic-deploy"
require_relative "resources/repo"
require_relative "resources/romver"
require_relative "resources/rss"
require_relative "resources/rubygems"
require_relative "resources/slack-notification"

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
      end.sort_by do |key, value|
        value.count
      end.reverse.to_h
    end

    def self.owned_by(owner)
      owned_resources.select do |resource|
        owner === resource.const_get(:GITHUB_OWNER)
      end
    end
  end
end

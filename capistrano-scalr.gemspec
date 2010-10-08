# -*- encoding: utf-8 -*-
require File.expand_path("../lib/capistrano-scalr/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capistrano-scalr"
  s.version     = Capistrano::Scalr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/capistrano-scalr"
  s.summary     = "Capistrano recipes for deploying to Scalr"
  s.description = "Capistrano recipes for deploying to Scalr"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "capistrano-scalr"

  s.add_development_dependency "bundler", ">= 1.0.0"
  
  s.add_dependency "capistrano", ">= 2.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

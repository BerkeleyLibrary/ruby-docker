# frozen_string_literal: true

module BerkeleyLibrary
  module Docker
    class ModuleInfo
      NAME = 'berkeley_library-docker'
      AUTHOR = 'Dan Schmidt'
      AUTHOR_EMAIL = 'danschmidt5189@berkeley.edu'
      SUMMARY = 'Utility functions for Dockerizing Ruby apps'
      DESCRIPTION = 'Utility functions for making Ruby apps "just work" in Docker containers.'
      LICENSE = 'MIT'
      VERSION = '0.3.0.a1'
      HOMEPAGE = 'https://github.com/BerkeleyLibrary/ruby-docker'

      private_class_method :new
    end
  end
end

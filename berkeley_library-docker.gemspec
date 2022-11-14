File.expand_path('lib', __dir__).tap do |lib|
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
end

ruby_version = begin
  ruby_version_file = File.expand_path('.ruby-version', __dir__)
  File.read(ruby_version_file).strip
end

require 'berkeley_library/docker/module_info'

Gem::Specification.new do |spec|
  spec.name = BerkeleyLibrary::Docker::ModuleInfo::NAME
  spec.author = BerkeleyLibrary::Docker::ModuleInfo::AUTHOR
  spec.email = BerkeleyLibrary::Docker::ModuleInfo::AUTHOR_EMAIL
  spec.summary = BerkeleyLibrary::Docker::ModuleInfo::SUMMARY
  spec.description = BerkeleyLibrary::Docker::ModuleInfo::DESCRIPTION
  spec.license = BerkeleyLibrary::Docker::ModuleInfo::LICENSE
  spec.version = BerkeleyLibrary::Docker::ModuleInfo::VERSION
  spec.homepage = BerkeleyLibrary::Docker::ModuleInfo::HOMEPAGE

  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features|artifacts)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = ">= #{ruby_version}"

  spec.add_development_dependency 'rails', '~> 6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rspec-support', '~> 3.9'

  spec.metadata['rubygems_mfa_required'] = 'true'
end

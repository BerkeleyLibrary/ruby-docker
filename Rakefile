ENV['BUNDLE_GEMFILE'] ||= File.expand_path('Gemfile', __dir__)
require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'rubygems/gem_runner'

File.expand_path('lib', __dir__).tap do |lib|
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

if ENV['CI']
  ENV['RAILS_ENV'] = 'test'
end

desc 'Clean, check, build gem'
task default: %i[clean spec gem]

desc 'Remove artifacts directory, except for .keep file'
task :clean do
  FileUtils.rm_rf('artifacts')
  FileUtils.mkdir('artifacts')
  FileUtils.touch(File.join('artifacts', '.keep'))
end

desc 'Build the gem'
task :gem do
  gem_name = [
    BerkeleyLibrary::Docker::ModuleInfo::NAME,
    BerkeleyLibrary::Docker::ModuleInfo::VERSION,
  ].join('-')
  output_file = File.join(__dir__, 'artifacts', gem_name)

  Gem::GemRunner.new.run(['build', '--output', output_file])
end

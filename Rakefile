require 'rubygems'
require 'rake/gempackagetask'

GEM_NAME = "cart"
AUTHOR = "Jakub Stastny aka Botanicus"
EMAIL = "knava.bestvinensis@gmail.com"
HOMEPAGE = "http://101Ideas.cz/"
SUMMARY = "Framework agnostic cart solution"
GEM_VERSION = "0.0.1"

spec = Gem::Specification.new do |s|
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile", "LICENSE"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.files = %w(LICENSE README.textile Rakefile) + Dir.glob("{lib,spec,app,public,stubs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

def sudo_gem(cmd)
  sh "#{SUDO} #{RUBY} -S gem #{cmd}", :verbose => false
end

desc "Install #{GEM_NAME} #{GEM_VERSION}"
task :install => [ :package ] do
  sudo_gem "install --local pkg/#{GEM_NAME}-#{GEM_VERSION} --no-update-sources"
end

desc "Uninstall #{GEM_NAME} #{GEM_VERSION}"
task :uninstall => [ :clobber ] do
  sudo_gem "uninstall #{GEM_NAME} -v#{GEM_VERSION} -Ix"
end

require 'spec/rake/spectask'
desc 'Default: run spec examples'
task :default => 'spec'

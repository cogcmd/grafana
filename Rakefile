require 'yaml'

# Make sure we're running from the directory the Rakefile lives in since
# many things (ie: docker build, config reading) use relative paths.
Dir.chdir(File.dirname(__FILE__))

BUNDLE_CONFIG = YAML.load(File.read('config.yaml'))
BUNDLE_VERSION = BUNDLE_CONFIG['version']
BUNDLE_IMAGE = "#{BUNDLE_CONFIG['docker']['image']}:#{BUNDLE_CONFIG['docker']['tag']}"

task :image do |t|
  sh 'docker', 'build', '-t', BUNDLE_IMAGE, '.'
end

task push: [:image] do |t|
  sh 'docker', 'push', BUNDLE_IMAGE
end

task release: [:push] do |t|
	sh 'git', 'tag', BUNDLE_VERSION
	sh 'git', 'push', 'origin', BUNDLE_VERSION
end

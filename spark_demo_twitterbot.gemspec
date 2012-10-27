# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spark_demo_twitterbot/version'

Gem::Specification.new do |gem|
  gem.name          = "spark_demo_twitterbot"
  gem.version       = SparkDemoTwitterbot::VERSION
  gem.authors       = ["Zachary Crockett"]
  gem.email         = ["zachary@sparkdevices.com"]
  gem.description   = %q{App to demo controlling lights from a twitter stream using sparkdevices.com}
  gem.summary       = %q{Spark Devices twitter bot demo}
  gem.homepage      = "http://www.sparkdevices.com/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'em-http-request'
  gem.add_runtime_dependency 'simple_oauth'

  gem.add_development_dependency 'rspec'
end

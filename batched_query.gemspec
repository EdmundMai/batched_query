# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'batched_query/version'

Gem::Specification.new do |spec|
  spec.name          = "batched_query"
  spec.version       = BatchedQuery::VERSION
  spec.authors       = ["Edmund Mai"]
  spec.email         = ["edmundmai@gmail.com"]
  spec.summary       = %q{Substitute for ActiveRecord's find_each and find_in_batches methods}
  spec.description   = %q{Allows you to separate queries that return large results into several subsets to lower memory consumption}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.add_development_dependency "rspec"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end

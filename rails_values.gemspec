Gem::Specification.new do |spec|
  spec.name          = 'rails_values'
  spec.version       = '1.0.0'
  spec.authors       = ['grant']
  spec.email         = ['grant@nexl.io']

  spec.summary       = 'Basic Rich types in your rails models'
  spec.description   = 'Use EmailAddress, Subdomain, Country, HttpUrl types in your rails models'
  spec.homepage      = 'https://github.com/NEXL-LTS/rails_values'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["#{__dir__}/**"].reject { |f| f.match(%r{^(coverage|spec|vendor)/}) }

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'actionview', '>= 6.0.0', '< 7.0'
  spec.add_dependency 'activejob', '>= 6.0.0', '< 7.0'
  spec.add_dependency 'activemodel', '>= 6.0.0', '< 7.0'
  spec.add_dependency 'activesupport', '>= 6.0.0', '< 7.0'
  spec.add_dependency 'countries', '>= 3.0.0', '< 4.0'
  spec.add_dependency 'mail', '>= 2.7.1', '< 3.0'
  spec.add_dependency 'money', '>= 6.13.2', '< 7.0'
  spec.add_dependency 'multi_json', '>= 1.0.0', '< 2.0'
  spec.add_dependency 'public_suffix', '< 5.0'
end

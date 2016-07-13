Gem::Specification.new do |s|
  s.name        = 'letsgetbetter'
  s.version     = '0.1.0'
  s.date        = Date.today.to_s
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.summary     = 'open source project github repo reporting'
  s.description = s.summary
  s.authors     = ['Tim Smith']
  s.email       = 'tsmith84@gmail.com'
  s.homepage    = 'http://www.github.com/tas50/letsgetbetter'
  s.license     = 'Apache-2.0'

  s.required_ruby_version = '>= 2.1.0'
  s.add_dependency 'octokit', '~> 4.0'
  s.add_dependency 'command_line_reporter'
  s.add_dependency 'faraday-http-cache'
  s.add_development_dependency 'rake', '< 11'
  s.add_development_dependency 'rubocop', '~> 0.38'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.name
  s.require_paths = ['lib']
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options = ['--line-numbers', '--inline-source', '--title', 'letsgetbetter', '--main', 'README.md']
end

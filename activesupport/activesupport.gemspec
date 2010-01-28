Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "activesupport"
  s.version = "3.0.pre"
  s.date = "2009-09-01"
  s.summary = "Support and utility classes used by the Rails framework."
  s.description = %q{Utility library which carries commonly used classes and goodies from the Rails framework}

  s.add_dependency('i18n', '~> 0.3.0')
  s.add_dependency('tzinfo', '~> 0.3.16')
  s.add_dependency('builder', '~> 2.1.2')
  s.add_dependency('memcache-client', '~> 1.7.5')

  s.files = Dir['CHANGELOG', 'README', 'lib/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true

  s.author = "David Heinemeier Hansson"
  s.email = "david@loudthinking.com"
  s.homepage = "http://www.rubyonrails.org"
  s.rubyforge_project = "activesupport"
end

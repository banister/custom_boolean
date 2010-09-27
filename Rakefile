require 'rake/gempackagetask'
require './lib/custom_boolean/version'

$dlext = Config::CONFIG['DLEXT']

specification = Gem::Specification.new do |s|
  s.name = "custom_boolean"
  s.summary = "Handrolled if/else expressions with customizable truthiness"
  s.version = CustomBoolean::VERSION
  s.date = Time.now.strftime '%Y-%m-%d'
  s.author = "John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.description = s.summary
  s.require_path = 'lib'
  s.platform = Gem::Platform::RUBY
  s.homepage = "http://banisterfiend.wordpress.com"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown"]
  s.rdoc_options << '--main' << 'README.markdown'
  
  s.files =  ["Rakefile", "README.markdown", "CHANGELOG", 
              "lib/custom_boolean.rb", "lib/custom_boolean/version.rb"] +
    FileList["examples/*.rb", "test/*.rb"].to_a
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = false
  package.need_tar = false
end


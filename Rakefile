require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rack-coderay"
    gem.summary = %Q{Rack middleware that automatically formats code syntax using CodeRay gem}
    gem.description = %Q{This Rack middleware component uses the CodeRay gem to automatically format code syntax by detecting a specific container in the final rendered markup.}
    gem.email = "phil@webficient.com"
    gem.homepage = "http://github.com/webficient/rack-coderay"
    gem.authors = ["Phil Misiowiec"]
    gem.files = FileList['lib/**/*.rb']
    gem.add_dependency 'coderay'
    gem.add_dependency 'hpricot'
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rack-coderay #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

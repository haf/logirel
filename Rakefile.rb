require 'bundler'
Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'; 
RSpec::Core::RakeTask.new(:spec)
# Requires Bundler and adds the 
#build, install and release 
#Rake tasks by way of calling Bundler::GemHelper.install_tasks. 
#The build task will build the current version of the gem and 
#store it under the pkg folder, the install task will build 
#and install the gem to our system (just like it would do if we 
#gem install'd it) and release will push the gem to Rubygems for 
#consumption by the public.

task :verify do
  changed_files = `git diff --cached --name-only`.split("\n") + `git diff --name-only`.split("\n")
  if !(changed_files == ['Rakefile.rb'] or changed_files.empty?)
    raise "Repository contains uncommitted changes; either commit or stash."
  end
end

desc 'Tag the repository in git with gem version number'
task :tag => :verify do
  v = SemVer.find
  Rake::Task["build"].invoke
  
  if `git tag`.split("\n").include?("#{v.to_s}")
    raise "Version #{v.to_s} has already been released! You cannot release it twice."
  end
  puts 'adding'
  `git add Rakefile.rb`
  puts 'committing'
  `git commit -m "Released version #{v.to_s}"`
  puts 'tagging'
  `git tag #{v.to_s}`
  puts 'locally installing'
  Rake::Task["install"].invoke
end

desc "push data and tags"
task :push => :verify do
  puts 'pushing tags'
  `git push --tags`
  puts 'pushing'
  `git push`
end
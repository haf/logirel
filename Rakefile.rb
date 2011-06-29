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

desc 'Tag the repository in git with gem version number'
task :tag do
  changed_files = `git diff --cached --name-only`.split("\n") + `git diff --name-only`.split("\n")
  v = SemVer.find
  if changed_files == ['Rakefile.rb'] or changed_files.empty?
    Rake::Task["build"].invoke
  
    if `git tag`.split("\n").include?("#{v.to_s}")
      raise "Version #{v.to_s} has already been released"
    end
	puts 'adding'
    `git add .`
    puts 'committing'
	`git commit -m "Released version #{v.to_s}"`
	puts 'tagging'
	`git tag #{v.to_s}`
	puts 'pushing tags'
    #`git push --tags`
	#puts 'pushing'
    #`git push`
  else
    raise "Repository contains uncommitted changes; either commit or stash."
  end
end
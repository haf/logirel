require 'logirel/initer'
require 'logirel/version'
require 'logirel/q_model'
require 'uuid'
require 'thor'

module Logirel
  class Application < Thor
    
	desc "Convert projects to rake", "Convert the current folder's projects (src) into a rake+albacore build"
	def convert
      
      puts "Logirel version #{Logirel::VERSION}"
      dir = Dir.pwd
      
      puts ""
      puts "Directories Selection"
      puts "---------------------"
      puts "Current directory: " + dir
      q = "Is this the 'src' dir? Contains projects: (#{Initer.new('.').parse_folders.inspect})"
      if (!BoolQ.new(q, true).exec)
        dir = StrQ.new("Specify directory.", lambda { |dir| !dir.empty? && Dir.exists?(dir) }).exec
      end
      
      buildscripts = StrQ.new("Buildscripts Directory", "../buildscripts").exec
      
      puts ""
      puts "Project Selection"
      puts "-----------------"
      
      selected_projs = Initer.new(dir).parse_folders.
        map { |f| 
          BoolQ.new(f, File.basename(f)).exec
        }
      
      puts ""
      puts "Project Meta-Data Definitions"
      puts "-----------------------------"
      
      metas = selected_projs.map do |p|
        
        base = File.basename(p)
        p_dir = File.join(dir, base)
        
        {
          :dir => p_dir,
      	  :title => StrQ.new("Title", base).exec,
      	  :test_dir => StrQ.new("Test Directory", base + ".Tests").exec,
      	  :description => StrQ.new("Description", "#{base} at commit #{`git log --pretty-format=%H`}").exec,
      	  :copyright => StrQ.new("Copyright").exec,
      	  :authors => StrQ.new("Authors").exec,
      	  :company => StrQ.new("Company").exec,
      	  :nuget_key => StrQ.new("NuGet key", base).exec,
      	  :ruby_key => StrQ.new("Ruby key (e.g. 'autotx')").exec,
      	  :guid => UUID.new
        }
      end
	  
	  Initer.new(dir).init_project_details(buildscripts, metas)
      
      # TODO: paths
  	
      # TODO: Create rakefile!
      
      # TODO: tasks in rakefile.rb
    end
  end
end
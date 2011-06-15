require 'logirel/initer'
require 'logirel/version'
require 'logirel/q_model'
require 'uuid'
require 'thor'
require 'FileUtils'

module Logirel
 class CLI < Thor
    
	desc "init", "Convert the current folder's projects (src) into a rake+albacore build"
	def init(root_dir = Dir.pwd)
      
      puts "Logirel version #{Logirel::VERSION}"
	  curr = Dir.pwd
      
      puts ""
      puts "Directories Selection"
      puts "---------------------"
	  
	  folder = lambda { |query, default|
	    StrQ.new(query, default, STDIN, lambda { |dir| !dir.empty? && Dir.exists?(dir) }, STDOUT)
	  }
	  
	  src_folders = Initer.new('./src').parse_folders.inspect
      dir = folder.call("Source Directory. Default contains (#{src_folders})", "./src").exec
      buildscripts = folder.call("Buildscripts Directory", "./buildscripts").exec
	  tools = folder.call("Tools Directory", "./tools").exec
	  initer = Initer.new(dir)
	  initer.buildscripts_path = buildscripts
	  
	  puts "initing semver in folder above #{dir}"
	  `semver init`
      puts ""
      puts "Project Selection"
      puts "-----------------"
      
      selected_projs = initer.parse_folders.
        map { |f| 
          BoolQ.new(f, File.basename(f)).exec # TODO: return bool
        }

      raise "no no no"
      
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
      
	  initer.init_project_details(metas)
      initer.create_paths_rb
      initer.create_environement_rb 
      initer.init_rakefile
    end
  end
end
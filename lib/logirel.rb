require 'logirel/initer'
require 'logirel/version'
require 'logirel/q_model'
require 'UUID'

module Logirel
  class Application
    def run(*ARGV)
      
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
      
      # TODO: test whether buildscripts/project_details.rb exists
      details_path = File.join(buildscripts, "project_details.rb")
      File.new(details_path, "w") do |f|
        f.puts %q{ 
  Projects = \{
      }
      end
      
      metas.each do |m|
        File.open(details_path, "w") do |f|
          k = m.ruby_key
      	m.remove('ruby_key')
          f.puts ":#{m.ruby_key} = #{p(m)}"
      	f.puts ","
        end 
      end
      
      File.open(details_path, "w") do |f|
          f.puts %q{ 
        \}
      }
      end
      
      # TODO: paths
  	
      # TODO: Create rakefile!
      
      # TODO: tasks in rakefile.rb
    end
  end
end
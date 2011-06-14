module Logirel
  require 'semver'

  class Initer
  
	attr_accessor :root_path
	
	def initialize(root = '.')
	  @root_path = root
	end
  
    def get_commands
	  cmd ||= []
	  cmd << "semver init"
	  cmd << "bin\NuGet.exe update"
	end
	
	def nuget_from_codeplex(cp_ver, gem_ver)
	  (cp_ver <=> gem_ver) > 0
	end
	
	def create_structure
	  # puts "making dir #{@root_path}"
	  ['buildscripts', 'src'].each do |d|
	    path = File.join(@root_path, d)
	    Dir.mkdir path unless Dir.exists? path
	  end
	end
	
	def parse_folders
	  src = File.join(@root_path, 'src', '*')
	  Dir.
	    glob(src).
	    keep_if{ |i| 
		  projs = File.join(i, "*.{csproj,vbproj,fsproj}")
		  File.directory? i and Dir.glob(projs).length > 0
		}.
		map{|x| File.basename(x) }
	end
	
	def init_rakefile
	  File.open(File.join(@root_path, "Rakefile.rb"), "w") do |f|
	    f.puts "require 'bundler'"
	  end
	end
	
	def init_project_details(buildscripts, metadata)
	  details_path = File.open(File.join(buildscripts, "project_details.rb"), "w") do |f|
        f.puts %q{ 
Projects = \{
}
	  end
	  
	  metadata.each do |m|
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
	end
  end
end
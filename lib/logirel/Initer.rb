module Logirel
  require 'semver'

  class Initer
  
	attr_accessor :root_path
	
	def initialize(root = '.'); @root_path = root; end
	def set_root(root); @root_path = root; end
  
    def get_commands
	  cmd ||= []
	  cmd << "semver init"
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
	
	def create_paths_rb
	  path = File.join(@root_path, "buildscripts", "paths.rb")
	  File.open(path, "w") do |f|
	    f.puts "."
		# TODO: generate from interactive
	  end
	end
	
	def create_environement_rb
	  path = File.join(@root_path, "buildscripts", "environment.rb")
	  File.open(path, "w") do |f|
	    # todo: read from raw.gh.com/logirel/master/content/environment.rb and write to this file.
	  end
	end
	
	def create_project_details_rb
	  path = File.join(@root_path, "buildscripts", "project_details.rb")
	  File.open(path, "w") do |f|
	    f.puts "."
		# TODO: generate from interactive
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
  end
end
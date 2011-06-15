require 'semver'
require 'enumerator'
require 'net/http'

module Logirel
  class Initer
	
	attr_accessor :root_path, :buildscripts_path
	
	def initialize(root = '.', buildscripts = 'buildscripts'); 
	                @root_path = root
					@buildscripts_path = buildscripts; end
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
	  path = File.join(@root_path, @buildscripts_path, "paths.rb")
	  File.open(path, "w") do |f|
	    f.puts "."
		# TODO: generate from interactive
	  end
	end
	
	def create_environement_rb
	  path = File.join(@root_path, @buildscripts_path, "environment.rb")
	  File.open(path, "w") do |f|
	    f.puts Net::HTTP.get(
		  URI.parse('https://raw.github.com/haf/logirel/master/content/environment.rb'))
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
	
	def init_gemfile
	  File.open(File.join(@root_path, "Gemfile"), "w") do |f|
        f.puts 'source "http://rubygems.org"'
        f.puts 'gem "albacore"'
		f.puts 'gem "semver"'
		f.puts 'gem "bundler"'
	  end
	end
	
	def init_utils
	  path = File.join(@root_path, @buildscripts_path, "utils.rb")
	  File.open(path, "w") do |f|
	    f.puts Net::HTTP.get(
		  URI.parse('https://raw.github.com/haf/logirel/master/content/utils.rb'))
	  end
	end
	
	def build_tasks(metas)
	  
	end
	
	def assembly_infos(metas)
	  
	end
	# asm info for every nuget
	def nugets(metas)
	  
	end
	
	def init_rakefile(metas)
	  build_keys = metas.map{|m| ":build_"+m.ruby_key}
	  File.open(File.join(@root_path, "Rakefile.rb"), "w") do |f|
	    f.puts %q{
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require # if rake gets a wee bit too slow, you may remove this
require 'albacore'
require 'semver'
require 'rake/clean'
require '#{buildscripts_path}/project_details'
require '#{buildscripts_path}/paths'
require '#{buildscripts_path}/utils'
require '#{buildscripts_path}/environment'
task :default => [:release]
task :debug => ["env:debug", :build]
task :release => ["env:release", :build]
task :ci => ["env:release", :build, :package]
}
        f.puts "task :build => #{build_keys.inspect}"
		
		f.puts build_tasks(metas)
	  end
	end
	
	def init_project_details(metadata)
      File.open(File.join(@root_path, @buildscripts_path, "project_details.rb"), "w") do |f|
	    f.puts "Projects = {"
		# m = ["my key", value]
		# projects[m[0]] = value
	    metadata.keys.each_with_index do |key, index|
		  if index == metadata.length-1
            f.puts ":#{key} = #{p(metadata[key])}"
		  else 
		    f.puts ":#{key} = #{p(metadata[key])},"
		  end
        end
		f.puts "}"
      end
	end
  end
end
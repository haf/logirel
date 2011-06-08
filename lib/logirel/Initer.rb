module Logirel
  require 'rubygems'
  require 'semver'

  class Initer
    
	attr_accessor :root_path
	
	def initialize(root = '.')
	  @root_path = root
	end
  
    def get_commands
	  cmd ||= []
	  cmd << "gem update"
	  cmd << "bundle install"
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
  end
  
  class NuGet
    def remote_ver
	  ver = Version.new
	  ver.parse_numeric(`gem query -r -n nuget`)
	end
  end
  
  class Version < SemVer
    def parse_numeric(str)
	  str.scan(/(\d{1,5}).?/).flatten.collect{|x| x.to_i}
	end
  end
  
  
end
require 'logirel/initer'
require 'logirel/version'
require 'logirel/nuget'
require 'logirel/initer'
require 'construct'
require 'FileUtils'

describe Logirel::Initer, "when reflecting upon previous project strucure" do
  it "should correctly parse the names of existing projects" do
    
	with_sample_projects do |c|
	  r = Logirel::Initer.new(c)
	
	  # initer should parse names:
	  r.parse_folders.should =~ ['A', 'C']
	end
  end
end

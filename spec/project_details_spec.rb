require 'logirel'
requre 'FileUtils'

describe Logirel::Logirel, "when initilizing project details" do 
  
  before(:each) do 
    @temp = "buildscripts"
	Dir.mkdir(@temp) unless Dir.exists?(@temp)
	@r = Logirel::Logirel.new(@temp)
  end
  
  after(:each) do
    FileUtils.rm_rf(@temp) if Dir.exists?(@temp)
  end
  
  if "should create project_details.rb" do 
    File.exitist?(File.join(@temp, "project_details.rb")).should be_true
  end
  
end
require 'logirel'
require 'FileUtils'

describe Logirel::Initer, "when initilizing project details" do 
  
  before(:each) do 
    @temp = "buildscripts"
	Dir.mkdir(@temp) unless Dir.exists?(@temp)
	@r = Logirel::Initer.new(@temp)
	@r.init_project_details(@temp, ['A', 'B'])
  end
  
  after(:each) do
    FileUtils.rm_rf(@temp) if Dir.exists?(@temp)
  end
  
  it "should create project_details.rb" do
    File.exists?(File.join(@temp, "project_details.rb")).should be_true
  end

end
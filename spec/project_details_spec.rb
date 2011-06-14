require 'logirel'
require 'FileUtils'

describe Logirel::Initer, "when initilizing project details" do 
  
  before(:each) do 
    @temp = "fs-" + rand().to_s
	Dir.mkdir(@temp) unless Dir.exists?(@temp)
	@r = Logirel::Initer.new(@temp)
  end
  
  after(:each) do
    FileUtils.rm_rf(@temp) if Dir.exists?(@temp)
  end
  
  
end
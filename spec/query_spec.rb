require 'logirel/querier'
require 'logirel/with_sample_projects'

describe Logirel::Querier, "when getting available directories and having querier return the correct data structures" do
    
  before(:each) do
    @q = Querier.new
  end 
  
  it "should create a query for every project folder" do
    with_sample_projects do |construct|
	  r = Initer.new(construct)  
	  @q.
	end
  end
  
  it "should not create a query for those project folders without *proj files" do
  
  end
  
  it "should be possible to execute the query in memory and have it return the correct meta data for the to-the-folder corresponding project" do
  
  end
end
require 'logirel/initer'

describe Logirel::Initer, "when starting a new project" do

  before(:each) do
    @i = Logirel::Initer.new
  end
  
  it "should start by performing an upgrade" do
    @i.init[0].should eql("gem update")
  end
  
  it "should then proceed running bundle install" do
    @i.init[1].should eql("bundle install")
  end
end
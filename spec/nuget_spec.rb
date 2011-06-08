
describe Logirel::NuGet, "when determining source" do
  before(:each) do
	@ng = Logirel::NuGet.new
  end
  it "should be able to get nuget version" do
    pending("I'm annoying their server...")
	ver = @ng.remote_ver
	ver.length.should eql(4)
  end
end

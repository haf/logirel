require 'logirel'
describe Logirel::Version, "in general" do
  before(:each) do
    @v = Logirel::Version.new
  end

  it "should be able to parse numerics" do
    @v.parse_numeric("1.3.677.32578").should eql([1, 3, 677, 32578])
  end
end
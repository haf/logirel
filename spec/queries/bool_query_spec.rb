require 'logirel/q_model'
describe Logirel::BoolQ, "when given input" do
  it "input says no, second time" do
    io = StringIO.new "x\nn"
    b = BoolQ.new "Yes or no?", true, io, io
	b.exec.should be_false
  end
  it "input says yet, second time" do
    io = StringIO.new "x\ny"
    b = BoolQ.new "Yes or no?", false, io, io
	b.exec.should be_true
  end
  it "input says yes" do 
    io = StringIO.new "y"
    b = BoolQ.new "Yes or no?", false, io, io
	b.exec.should be_true
  end
  it "input says no" do
    io = StringIO.new "n"
    b = BoolQ.new("Yes or no?", true, io, io)
	b.exec.should be_false
  end
  it "input is default" do
    io = StringIO.new "\n"
    b = BoolQ.new("Yes or no?", true, io, io)
	b.exec.should be_true
  end
end

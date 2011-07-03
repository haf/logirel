require 'logirel/queries'

module Logirel
  module Queries
    describe BoolQ, "when given input" do
      before(:each) { @out = StringIO.new }

      it "input says no, second time" do
        io = StringIO.new "x\nn"
        b = BoolQ.new "Yes or no?", true, io, @out
        b.exec.should be_false
      end
      it "input says yet, second time" do
        io = StringIO.new "x\ny"
        b = BoolQ.new "Yes or no?", false, io, @out
        b.exec.should be_true
      end
      it "input says yes" do
        io = StringIO.new "y"
        b = BoolQ.new "Yes or no?", false, io, @out
        b.exec.should be_true
      end
      it "input says no" do
        io = StringIO.new "n"
        b = BoolQ.new("Yes or no?", true, io, @out)
        b.exec.should be_false
      end
      it "input is default" do
        io = StringIO.new "\n"
        b = BoolQ.new("Yes or no?", true, io, @out)
        b.exec.should be_true
      end
    end
  end
end

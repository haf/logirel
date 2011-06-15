require 'logirel/q_model'
require 'spec_helper'

describe Logirel::StrQ, "in its default mode of operation, when reading props" do
  before(:all) { @q = StrQ.new "Q??", "def" }
  subject { @q }
  it { should respond_to :question }
  it { should respond_to :default }
  specify { @q.answer.should eql("def") }
  specify { @q.question.should eql("Q??") }
end

describe Logirel::StrQ, "when feeding it OK input" do
  before(:each) do 
    @io = StringIO.new "My Answer"
    @validator = double('validator')
    @validator.should_receive(:call).once.
      with(an_instance_of(String)).
      and_return(true)
  end
  subject { StrQ.new("q?", "def", @io, @validator) }
  specify { 
    subject.exec.should eql("My Answer") and 
    subject.answer.should eql("My Answer") 
  }
end

describe Logirel::StrQ, "when feeding it bad input" do
  before(:each) do 
    @io = StringIO.new "My Bad Answer\nAnother Bad Answer\nOKAnswer!"
    
    @validator = double('validator')
    @validator.should_receive(:call).exactly(3).times.
      with(an_instance_of(String)).
      and_return(false, false, true)
  end
  subject { StrQ.new("q?", "def", @io, @validator) }
  specify { subject.exec.should == "OKAnswer!" }
end

describe Logirel::StrQ, "when accepting the defaults" do
  before(:each) do 
    @io = StringIO.new "\n"
	
    @validator = double('validator')
    @validator.should_receive(:call).never.
      with(an_instance_of(String)).
	# the validator should never be called for empty input if we have a default
      and_return(false)
  end
  subject { StrQ.new("q?", "def", @io, @validator) }
  specify {
    subject.exec.should eql("def") and 
    subject.answer.should eql("def") 
  }
end
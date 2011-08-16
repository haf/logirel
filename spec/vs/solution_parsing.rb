require 'logirel/vs/solution'

module Logirel
  module VS
    describe Solution, "when parsing sample sln" do
      before(:each) {
        @path = 'sample-data/src/Logirel.sln'
        puts File.expand_path @path
      }
      it "should exist" do
        File.exists?(@path).should be_true
      end
      subject { Solution.new @path }

      specify {
        subject.test_projects.should
      }
    end
  end
end
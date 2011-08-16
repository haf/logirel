require 'logirel/vs'

module Logirel
  module VS
    describe Solution, "when parsing sample sln" do
      before(:each) {
        @path = 'sample-data/src/Logirel.sln'
        puts File.expand_path @path
      }
      
      subject { Solution.new @path }

      specify {
        File.exists?(@path).should be_true
      }
      
      specify {
        subject.test_projects.collect{|p|p.name}.should =~ ["Logirel.ConsoleApp.Tests"] and
          subject.test_projects.length.should eql(1)
      }
      
      specify { subject.projects.collect{|p|p.name}.should =~ ["Logirel.ClassLib", "Logirel.ConsoleApp", "Logirel.ConsoleApp.Tests", "Logirel.FubuMVCApp", "Logirel.Mvc2App"] }
    end
  end
end
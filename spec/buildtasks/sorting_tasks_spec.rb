require 'logirel/buildtasks/orderer'
require 'logirel/buildtasks/buildtask'
require 'tsort'

module Logirel
  module BuildTasks
    describe Orderer, "when sorting by dependencies" do
      before(:each) {
        @orderer = Orderer.new
        @orderer.add [:default_target], [:create_rakefile], BuildTask.new(:default_target)
        @orderer.add [:create_rakefile], [],  BuildTask.new(:create_rakefile)
      }
      
      subject {
        @orderer.tsort()
      }

      it "orders the results correctly" do
        subject.collect { |n| n[0] }.should =~ [:default_target, :create_rakefile]
      end
    end
  end
end
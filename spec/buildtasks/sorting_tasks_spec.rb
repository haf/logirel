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

      # Returns a topologically sorted array of nodes. The array is sorted from children to parents,
      # i.e. the first element has no child (deps) and the last node has no parent.
      it "orders the results in order of having no parent, then lastly having no children" do
        subject.
            keep_if{ |n| n.is_a?(Array) }.
            collect { |n| n[0][0] }.should =~ [:create_rakefile, :default_target]

      end
    end

    describe BuildTasks, "" do
    end
  end
end
require 'logirel/querier'
require File.dirname(__FILE__) + '/../support/with_sample_projects'

describe Logirel::Querier, "when getting available directories and having querier return the correct data structures" do

  before(:each) do
    @q = Logirel::Querier.new
  end

  it "should create a query for every project folder" do
    with_sample_projects do |construct|
      r = Logirel::Initer.new(construct)
      folders = r.parse_folders
      qs = @q.include_package_for(folders)
      qs.length.should >= 2
      qs.each do |q|
        folders.any? do |f|
          q.question.include? "'#{f}'"
        end
      end
    end
  end

  it "should not create a query for those project folders without *proj files" do
    with_sample_projects do |construct|
      # given
      r = Logirel::Initer.new(construct)
      folders = r.parse_folders
      # then
      @q.include_package_for(folders).map { |q| q.question }.
          each { |str| str.include?("'B'").should be_false }
    end
  end

  it "should return two strings when two questions are asked" do
    with_sample_projects do |construct|
      # given
      r = Logirel::Initer.new(construct)
      folders = r.parse_folders
      # then
      qs = @q.include_package_for(folders)
      qs.length.should eq(2)
    end
  end
end
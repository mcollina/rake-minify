require File.dirname(__FILE__) + "/../../spec_helper.rb"
require 'stringio'

class Rake::Minify
  describe Group do

    let(:parent) { double("parent") }
    subject { Group.new(parent) }

    before(:each) do
      parent.stub!(:build_path).and_return { |arg| arg }
    end

    def build_source(source_name, minify, stubs = {})
      source = double("source", stubs)
      Source.stub!(:new).with(source_name, :minify => minify).and_return(source)
      source
    end

    it "should have an add method that accepts a string" do
      lambda { subject.add("something") }.should_not raise_error
    end

    it "should have an add method that accepts a string and an hash" do
      lambda { subject.add("something", :minify => false) }.should_not raise_error
    end

    it "should create a new source with the passed args when calling add" do
      Source.should_receive(:new).with("something", :minify => false)
      subject.add("something", :minify => false)
    end

    it "should create a new source with the passed single arg when calling add" do
      Source.should_receive(:new).with("another", :minify => true)
      subject.add("another")
    end

    it "should concatenate all the sources when calling build" do
      s1 = build_source("a", false, :build => "aaaa");
      s2 = build_source("b", true, :build => "bbbb");

      subject.add("a", :minify => false)
      subject.add("b")
      subject.build.should == "aaaa\nbbbb"
    end

    it "should accept add inside the block passed to new" do
      s1 = build_source("a", false, :build => "aaaa");

      subject = Group.new(parent) do
        add("a", :minify => false)
      end
      
      subject.build.should == "aaaa"
    end

    it "should expose its parent dir method" do
      parent.should_receive(:dir).with("a_dir").and_yield("hello world")
      (subject.dir("a_dir") { |a| a }).should == "hello world" #weird method to test this
    end
  end
end

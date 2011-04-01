require File.dirname(__FILE__) + "/../spec_helper.rb"
require 'stringio'

describe Rake::Minify do

  def stub_open(source, content, mode=nil)
    io = StringIO.new(content)
    args = [source]
    args << mode if mode
    Kernel.stub!(:open).with(*args).and_yield(io)
    io
  end

  context "configured to minify a single file" do
    subject do 
      Rake::Minify.new do
        add("output", "source")
      end
    end

    before :each do
      stub_open("source",' var a =     "b"   ;')
      @output = stub_open("output","", "w")
    end

    it "should minify the input file when invoked" do
      subject.invoke
      @output.string.should == "var a=\"b\";"
    end
  end

  context "configured not to minify a single file" do
    subject do 
      Rake::Minify.new do
        add("output", "source", :minify => false)
      end
    end

    before :each do
      stub_open("source",' var a =     "b"   ;')
      @output = stub_open("output","", "w")
    end

    it "should not minify the input file when invoked" do
      subject.invoke
      @output.string.should == ' var a =     "b"   ;'
    end
  end

  context "configured to minify a group of files" do
    subject do
      Rake::Minify.new do
        group("output") do
          add("a")
          add("b")
        end
      end
    end

    before :each do
      stub_open("a",' var a =     "hello"   ;')
      stub_open("b",' var b =     "hello2"   ;')
      @output = stub_open("output","", "w")
    end

    it "should minify and concatenate the inputs" do
      subject.invoke
      @output.string.should == "var a=\"hello\";\nvar b=\"hello2\";"
    end
  end
end

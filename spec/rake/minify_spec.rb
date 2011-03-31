require File.dirname(__FILE__) + "/../spec_helper.rb"
require 'stringio'

describe Rake::Minify do

  context "configured to minify a single file" do
    subject do 
      Rake::Minify.new do
        add("output", "source")
      end
    end

    it "should minify the input file when invoked" do
      input = StringIO.new(' var a =     "b"   ;')
      Kernel.stub!(:open).with("source").and_yield(input)
      output = StringIO.new
      Kernel.stub!(:open).with("output", "w").and_yield(output)
      subject.invoke
      output.string.should == "\nvar a=\"b\";"
    end
  end

  context "configured not to minify a single file" do
    subject do 
      Rake::Minify.new do
        add("output", "source", :minify => false)
      end
    end

    it "should not minify the input file when invoked" do
      input = StringIO.new(' var a =     "b"   ;')
      Kernel.stub!(:open).with("source").and_yield(input)
      output = StringIO.new
      Kernel.stub!(:open).with("output", "w").and_yield(output)
      subject.invoke
      output.string.should == ' var a =     "b"   ;'
    end
  end
end

require File.dirname(__FILE__) + "/../../spec_helper.rb"
require 'stringio'

class Rake::Minify
  describe Source do
    context "configured to open 'a_source' and minify it" do
      subject { Source.new("a_source", true) }

      it "should open and minify the file" do
        input = StringIO.new(' var a =     "b"   ;')
        Kernel.stub!(:open).with("a_source").and_yield(input)
        subject.build.should == "var a=\"b\";"
      end
    end

    context "configured to open 'another_source' and to not minify it" do
      subject { Source.new("another_source", false) }

      it "should open and clone the file" do
        input = StringIO.new(' var a =     "b"   ;')
        Kernel.stub!(:open).with("another_source").and_yield(input)
        subject.build.should == ' var a =     "b"   ;'
      end
    end
  end
end

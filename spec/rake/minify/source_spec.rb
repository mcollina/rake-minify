require File.dirname(__FILE__) + "/../../spec_helper.rb"
require 'stringio'

class Rake::Minify
  describe Source do
    context "configured to open 'a_source' and minify it" do
      subject { Source.new("a_source", :minify => true) }

      it "should open and minify the file" do
        input = StringIO.new(' var a =     "b"   ;')
        Kernel.stub!(:open).with("a_source").and_yield(input)
        subject.build.should == "var a=\"b\";"
      end
    end

    context "configured to open 'another_source' and to not minify it" do
      subject { Source.new("another_source", :minify => false) }

      it "should open and clone the file" do
        input = StringIO.new(' var a =     "b"   ;')
        Kernel.stub!(:open).with("another_source").and_yield(input)
        subject.build.should == ' var a =     "b"   ;'
      end
    end

    context "compile a coffeescript file in bare mode" do
      subject { Source.new("a_source.coffee", :minify => true, :bare => true) }

      it "should open and minify the file" do
        input = StringIO.new(' a =     "b"   ')
        Kernel.stub!(:open).with("a_source.coffee").and_yield(input)
        subject.build.should == "var a;a=\"b\";"
      end
    end

    context "compile a coffeescript file in wrapped mode" do
      subject { Source.new("a_source.coffee", :minify => true, :bare => false) }

      it "should open and minify the file" do
        input = StringIO.new(' a =     "b"   ')
        Kernel.stub!(:open).with("a_source.coffee").and_yield(input)
        subject.build.should == "(function(){var a;a=\"b\";}).call(this);"
      end
    end

    context "compile a coffeescript file with no options" do
      subject { Source.new("a_source.coffee") }

      it "should open and minify the file" do
        input = StringIO.new(' a =     "b"   ')
        Kernel.stub!(:open).with("a_source.coffee").and_yield(input)
        subject.build.should == "(function(){var a;a=\"b\";}).call(this);";
      end

      it "should minify by default" do
        subject.minify.should be_true
      end
    end

    it "should not raise an error if initialized con options = nil" do
      lambda { Source.new("a.js", nil) }.should_not raise_error
    end
    
  end
end

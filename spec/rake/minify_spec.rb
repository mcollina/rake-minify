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

  def do_invoke
    subject.invoke
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
      do_invoke
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
      do_invoke
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
      do_invoke
      @output.string.should == "var a=\"hello\";\nvar b=\"hello2\";"
    end
  end

  context "configured to minify a file in a directory" do
    subject do 
      Rake::Minify.new do
        dir("the_dir") do
          add("output", "source")
        end
      end
    end

    before :each do
      stub_open("the_dir/source",' var a =     "b"   ;')
      @output = stub_open("output","", "w")
    end

    it "should minify the input file when invoked" do
      do_invoke
      @output.string.should == "var a=\"b\";"
    end
  end

  context "configured to minify a file in a deep directory" do
    subject do 
      Rake::Minify.new do
        dir("the_dir") do
          dir("another_dir") do
            add("output", "source")
          end
        end
      end
    end

    before :each do
      stub_open("the_dir/another_dir/source",' var a =     "b"   ;')
      @output = stub_open("output","", "w")
    end

    it "should minify the input file when invoked" do
      do_invoke
      @output.string.should == "var a=\"b\";"
    end
  end

  context "configured to minify multiple files in a deep directory" do
    subject do 
      Rake::Minify.new do
        dir("the_dir") do
          group("output") do
            dir("another_dir") do
              add("a")
            end
            add("b")
          end
        end
      end
    end

    before :each do
      stub_open("the_dir/another_dir/a",' var a =     "hello"   ;')
      stub_open("the_dir/b",' var b =     "hello2"   ;')
      @output = stub_open("output","", "w")
    end

    it "should minify the input file when invoked" do
      do_invoke
      @output.string.should == "var a=\"hello\";\nvar b=\"hello2\";"
    end
  end

  it "should accepts arguments" do
    Rake::Task.should_receive(:define_task).with(:a_task)
    Rake::Minify.new(:a_task) do
      add("output", "source")
    end
  end
end

require "./../spec_helper"
require "./../../src/mysqldumpsplitter/opt_parser.cr"
require "process"


SOURCE_MISSING_MESSAGE = "mysqldumpsplitter: source file is required\n"

HELP_MESSAGE = <<-MESSAGE
Usage: mysqldumpsplitter [arguments] source
    -h, --help                       Show this help
    -d, --desc                       Describe the tables in the dump


MESSAGE

class Project
  include Mysqldumpsplitter::OptParser
  extend Mysqldumpsplitter::OptParser
end


describe Mysqldumpsplitter::OptParser do

  describe "no options or arguments passed to program" do
    it "prints the help menu" do
      value = Process.run(ExecutablePath) do |proc|
        proc.error.gets_to_end
      end

      value.should eq(SOURCE_MISSING_MESSAGE + HELP_MESSAGE)
    end
  end

  describe "one option and no argument" do
    context "option --help" do

      it "prints the help menu" do
        value = Process.run(ExecutablePath, {"--help"}) do |proc|
          proc.output.gets_to_end
        end
        value.should eq(HELP_MESSAGE)
      end
    end

    context "option is --desc" do
      it "source argument is required" do
        value = Process.run(ExecutablePath, {"--desc"}) do |proc|
          proc.error.gets_to_end
        end

        value.should eq(SOURCE_MISSING_MESSAGE + HELP_MESSAGE)
      end
    end

    context "option is --desc with valid source" do
      it "source argument is required" do
        value = Process.run(ExecutablePath, {"--desc", "../spec/fixtures/person_titles.sql"}) do |proc|
          proc.error.gets_to_end
        end

        value.should eq("File '../spec/fixtures/person_titles.sql' doesn't exist\n")
      end
    end

    #context "option is --desc with valid source" do
      #it "source argument is required" do
        #puts path_from_root("../spec/fixtures/person_titles.sql")
        #value = Process.run(ExecutablePath, {"--desc", path_from_root("../spec/fixtures/person_titles.sql")}) do |proc|
          #proc.error.gets_to_end
        #end
        #expected = <<-OUTPUT
        #-------------------------------
        #Database		Tables
        #-------------------------------
            #person_titles
        #-------------------------------
        #OUTPUT
        #value.should eq(expected)
      #end
    #end

  end
  #describe "more options and no argument" do
  #end
    #context "all options are valid" do
    #end
    #context "one is valid and one is invalid" do
    #end
  #describe "no options and one argument" do
  #end
    #context "argument is valid" do
    #end
  #describe "no options and more arguments" do
  #end
    #context "one argument valid one invalid" do
    #end

  #describe "--desc" do
    #it "describes all the tables in the dump" do
      #Project.parse_args(["--desc"]).to_s.should eq("")
    #end
  #end
end

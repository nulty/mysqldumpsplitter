require "./../spec_helper"
require "./../../src/mysqldumpsplitter/opt_parser.cr"
require "process"


SOURCE_MISSING_MESSAGE = "mysqldumpsplitter: source file is required\n\n"

HELP_MESSAGE = <<-MESSAGE
Usage: mysqldumpsplitter [arguments] source
    -h, --help                       Show this help.
    -d, --desc                       Describe the tables in the dump.
    -e OBJECT, --extract OBJECT      Extract OBJECT to a file.
    -m NAME, --match NAME            NAME of OBJECT to be extracted.
    -c COMPRESSION, --compression COMPRESSION
                                     COMPRESSION format for output files.

    Definitions:
    OBJECT                           TABLE|ALLTABLES

    Examples:

    List the tables in the database dump
    $ mysqldumpsplitter --desc path/to/file.sql

    Extract a particular table
    $ mysqldumpsplitter --extract TABLE --match posts path/to/file.sql

    Extract all tables to individual files
    $ mysqldumpsplitter --extract ALLTABLES path/to/file.sql



MESSAGE

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
  end

  describe "extract option" do
    it "extract option must be valid" do
      value = Process.run(ExecutablePath, {"--extract=WRONG", "../spec/fixtures/person_titles.sql"}) do |proc|
        proc.error.gets_to_end
      end

     value.should match(/mysqldumpsplitter: --extract option \"WRONG\" is not valid/)
    end

    it "requires a match option to be present when extract value is TABLE" do
      value = Process.run(ExecutablePath, {"--extract=TABLE", "spec/fixtures/person_titles.sql"}) do |proc|
        proc.error.gets_to_end
      end

      value.should match(/mysqldumpsplitter: --match option is not valid/)
    end
  end

  describe "Compression" do
    it "defaults to gzip compression" do
      value = Process.run(ExecutablePath, {"--extract=TABLE", "--match=person_titles", "spec/fixtures/person_titles.sql"}) do |proc|
        proc.output.gets_to_end
      end

      #value.should match(/mysqldumpsplitter: --match option is not valid/)
      File.exists?("out/person_titles.sql.gz").should be_true
    ensure
      File.delete("out/person_titles.sql.gz")
    end

    it "exits with error if compression arg doesn't match COMPRESSIONS" do
      value = Process.run(ExecutablePath, {"--extract=TABLE", "--match=person_titles", "--compression=fake", "spec/fixtures/person_titles.sql"}) do |proc|
        proc.error.gets_to_end
      end

      value.should match(/mysqldumpsplitter: --compression option \"fake\" is not valid/)
    end
  end
end

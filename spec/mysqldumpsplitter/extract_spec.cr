require "./../spec_helper"
require "./../../src/mysqldumpsplitter/extract.cr"

describe Mysqldumpsplitter::Extract do
  Spec.after_each do
    File.delete("out/posts.sql") if File.exists?("out/posts.sql")
  end

  describe "Table" do
    it "creates the output file" do
      sql_file = File.open(path_from_root("fixtures/two_tables.sql"), "r")
      Mysqldumpsplitter::Extract.new(sql_file, "TABLE", "posts").call

      File.exists?("out/posts.sql").should be_truthy
    end

    it "writes the header of the data dump" do
      sql_file = File.open(path_from_root("fixtures/two_tables.sql"), "r")
      Mysqldumpsplitter::Extract.new(sql_file, "TABLE", "posts").call

      File.read("out/posts.sql").should match(/SET/)
    end


    it "writes the table data into the file" do
      sql_file = File.open(path_from_root("fixtures/two_tables.sql"), "r")

      Mysqldumpsplitter::Extract.new(sql_file, "TABLE", "posts").call

      File.read("out/posts.sql").should match(/DROP/)
    end
  end

  describe "All Tables in the file" do
    it "extracts all the tables to individual files" do

      sql_file = File.open(path_from_root("fixtures/two_tables.sql"), "r")

      Mysqldumpsplitter::Extract.new(sql_file, "ALLTABLES").call

      File.read("out/posts.sql").should match(/DROP/)
      File.read("out/users.sql").should match(/DROP/)
    ensure
      File.delete("out/users.sql") if File.exists?("out/users.sql")
    end
  end
end


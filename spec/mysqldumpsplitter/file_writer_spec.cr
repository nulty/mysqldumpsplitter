require "./../spec_helper"
require "./../../src/mysqldumpsplitter/file_writer.cr"
describe "FileWriter" do

  describe "gzip" do
    it "creates a file with the correct name" do
      compression = "gzip"
      input = "Hows it going?"

      fw = FileWriter.open("things", compression) do |file|
        file.puts(input)
      end

      File.exists?("out/things.sql.gz").should be_true
    ensure
      File.delete("out/things.sql.gz")
    end

    it "initializes with gzip" do
      compression = "gzip"
      input = "Hows it going?"

      FileWriter.open("things", compression) do |file|
        file.print(input)
      end

      out = File.open("out/things.sql.gz", "r") do |f|
        Gzip::Reader.open(f) do |gzip|
          gzip.gets_to_end
        end
      end

      out.should eq(input)
    ensure
      File.delete("out/things.sql.gz")
    end
  end

  describe "none" do
    it "initializes with none" do
      compression = "none"
      input = "Hows it going?"

      FileWriter.open("things", compression) do |file|
        file.print(input)
      end

      out = File.open("out/things.sql", "r") do |f|
        f.gets_to_end
      end

      out.should eq(input)
    ensure
      File.delete("out/things.sql")
    end
  end
end

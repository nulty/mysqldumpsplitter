require "../spec_helper"
require "../../src/mysqldumpsplitter/describe"

describe Mysqldumpsplitter::Describe do
  dump_file = File.open(File.expand_path("spec/fixtures/two_tables.sql", Root))

  describe "database" do
    it "outputs the correct values" do
      output = IO::Memory.new

      describer = Mysqldumpsplitter::Describe.new(dump_file, io: output)
      describer.call

      str = output.to_s
      str.should match(/Database		Tables/)
      str.should match(/posts/)
      str.should match(/users/)
    end
  end
end

module Mysqldumpsplitter
  class Describe
    DB_REGEX    = /^-- Current Database: `(?<db_name>.*)`/
    TABLE_REGEX = /^-- Table structure for table `(?<table_name>.*)`/

    def initialize(@source : File, @io : IO = STDOUT)
    end

    def call
      heading = <<-HEADING
        -------------------------------
        Database		Tables
        -------------------------------
        HEADING

      @io.puts heading

      @source.each_line do |line|
        next unless line.starts_with?("-")
        db_m = line.match(DB_REGEX)
        @io.puts db_m["db_name"] if db_m
        table_m = line.match(TABLE_REGEX)
        @io.puts "\t#{table_m["table_name"]}" if table_m
      end
    end
  end
end

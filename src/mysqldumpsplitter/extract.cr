module Mysqldumpsplitter
  class Extract
    def initialize(@dump_file : File, @table_name : String)
    end

    def call
      # Create the table dump file
      File.open("out/#{@table_name}.sql", "w") do |table_file|

        # Take the first 17 lines
        table_file.puts(header)

        writing = false
        @dump_file.each_line do |line|
          writing = false if line.starts_with?("-- Dump completed") || line.starts_with?("-- Table structure for table")
          writing = true if line.starts_with?("-- Table structure for table `#{@table_name}`")
          next unless writing

          table_file.puts(line)
        end
      end
    end

    private def header
      lines = [] of String
      @dump_file.each_line.with_index do |line, idx|
        break if idx > 16
        lines << line
      end
      lines.join
    end
  end
end

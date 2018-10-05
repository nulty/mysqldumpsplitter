module Mysqldumpsplitter
  class Extract
    def initialize(@dump_file : File, @object : String, @name : String = "")
    end

    @write_file : File | Nil
    @header : String | Nil

    def call
      case @object
      when "TABLE"
        # Create the table dump file
        File.open("out/#{@name}.sql", "w") do |target_file|

          # Take the first 17 lines
          target_file.puts(header)

          writing = false
          @dump_file.each_line do |line|
            writing = false if line.starts_with?("-- Dump completed") || line.starts_with?("-- Table structure for table")
            writing = true if line.starts_with?("-- Table structure for table `#{@name}`")
            next unless writing

            target_file.puts(line)
          end
        end

      when "ALLTABLES"
        # Keep local db header
        local_header = header

        writing = false

        @dump_file.each_line do |line|
          # We know a table starts here
          if line.starts_with?("-- Table structure for table")
            # Close the open write file
            if (wf = @write_file) && writing
              wf.close
              writing = false
            end

            table_name = line.match(/^-- Table structure for table `(.*)`/).try &.[1]
            @write_file = new_file("out/#{table_name}.sql")

            if wf = @write_file
              wf.puts(local_header)
            end
            writing = true
          elsif line.starts_with?("-- Dump completed")
            if (wf = @write_file) && writing
              wf.close
              writing = false
            end
          end

          if (wf = @write_file) && writing
            wf.puts(line)
            wf.close if line.starts_with?("-- Dump completed")
          end
        end
      end # end case statement

    end

    private def new_file(file_name : String)
      @write_file = File.open(file_name, "w")
    end

    private def header
      return @header if @header
      lines = [] of String
      @dump_file.each_line.with_index do |line, idx|
        break if idx > 16
        lines << line
      end
      @header = lines.join("\n")
    end
  end
end

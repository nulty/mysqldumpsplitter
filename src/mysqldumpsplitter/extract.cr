require "./file_writer"

module Mysqldumpsplitter
  class Extract
    @object : String
    @compression : String
    @name : String

    def initialize(@dump_file : File, options : Hash)

      @object = options.fetch(:object, "")
      @compression = options.fetch(:compression, "")
      @name = options.fetch(:name, "")
    end

    @write_file : File| IO | Nil
    @header : String | Nil

    def call
      case @object
      when "TABLE"
        # Create the table dump file
        FileWriter.open(@name, @compression) do |target_file|

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
          if line.starts_with?("-- Table structure for t")
            # Close the open write file
            if (wf = @write_file) && writing
              wf.close
              writing = false
            end

            table_name = line.match(/^-- Table structure for table `(.*)`/).try &.[1]
            puts "Writing #{table_name} to a file now" if table_name
            if table_name && !table_name.empty?
              @write_file = new_file(table_name)
            else
              raise ArgumentError.new
            end

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
          end
        end
      end # end case statement

    end

    private def new_file(file_name : String)
      @write_file = FileWriter.open(file_name, @compression)
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

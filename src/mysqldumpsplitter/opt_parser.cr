require "option_parser"

module Mysqldumpsplitter
  module OptParser
    OBJECTS = %(TABLE ALLTABLES)
    COMPRESSIONS = %(gzip none)

    def parse_args(args : Array(String))

      options = {} of Symbol => String
      invalid_options = [] of String
      message = ""
      describe = false
      help = false
      extract = false
      object = ""
      object_name = ""
      operation = "nil"
      source = ""
      compression = "gzip"
      options[:operation] = "nil"

      parser = OptionParser.parse(args) do |parser|
        parser.banner = "Usage: mysqldumpsplitter [arguments] source"
        parser.on("-h", "--help", "Show this help.") { help = true }
        parser.on("-d", "--desc", "Describe the tables in the dump.") { describe = true }
        parser.on("-e OBJECT", "--extract OBJECT", "Extract OBJECT to a file.") do |obj|
          if OBJECTS.includes?(obj)
            extract = true
            object = obj
          else
            STDERR.puts "mysqldumpsplitter: --extract option \"#{obj}\" is not valid"
            STDERR.puts parser_output(parser), ""
            exit(1)
          end
        end
        parser.on("-m NAME", "--match NAME", "NAME of OBJECT to be extracted.") { |name| object_name = name }
        parser.on("-c COMPRESSION", "--compression COMPRESSION", "COMPRESSION format for output files.") do |format|

          if COMPRESSIONS.includes?(format)
            compression = format
          else
            STDERR.puts "mysqldumpsplitter: --compression option \"#{format}\" is not valid"
            STDERR.puts parser_output(parser), ""
            exit(1)
          end
        end
        parser.invalid_option do |flag|
          invalid_options << flag
        end
        parser.unknown_args do |g|
          source = begin
                     g.first
                   rescue IndexError
                     ""
                   end
        end
      end

      # No arguments
      if !help && source.blank?
        STDERR.puts "mysqldumpsplitter: source file is required", ""
        STDERR.puts parser_output(parser), ""
        exit(1)
      end

      if compression.empty?
        compression = "gzip"
      end

      if help
        puts parser_output(parser), ""
        exit(0)
      else
        if invalid_options.size == 1
          message += "mysqldumpsplitter: invalid option -- #{invalid_options.first}\n"
          STDERR.puts message, "" if !message.empty?
          exit(1)
        elsif invalid_options.size > 1
          puts parser_output(parser), ""
          exit(1)
        end
      end

      if extract
        if object == "TABLE" && object_name.blank?
          STDERR.puts "mysqldumpsplitter: --match option is not valid", ""
          STDERR.puts parser_output(parser), ""
          exit(1)
        end
        options[:operation] = "extract"
        options[:name] = object_name
        options[:object] = object
        options[:compression] = compression
      end

      if describe
        options[:operation] = "describe"
      end
      options[:source] = source
      options
    end

    private def parser_output(parser)
      extra_info = <<-EXTRA
    Definitions:
    OBJECT                           TABLE|ALLTABLES

    Examples:

    List the tables in the database dump
    $ mysqldumpsplitter --desc path/to/file.sql

    Extract a particular table
    $ mysqldumpsplitter --extract TABLE --match posts path/to/file.sql

    Extract all tables to individual files
    $ mysqldumpsplitter --extract ALLTABLES path/to/file.sql


EXTRA
      [parser.to_s, extra_info].join("\n\n")
    end
  end
end


require "option_parser"

module Mysqldumpsplitter
  module OptParser

    def parse_args(args : Array(String))

      if args.any? && !args.last.starts_with?("-")
        source = args.last
      else
        source = ""
      end

      invalid_options = [] of String
      message = ""
      describe = false
      help = false
      extract = false
      extract_object = ""
      operation = "nil"

      parser = OptionParser.parse(args) do |parser|
        parser.banner = "Usage: mysqldumpsplitter [arguments] source"
        parser.on("-h", "--help", "Show this help.") { help = true }
        parser.on("-d", "--desc", "Describe the tables in the dump.") { describe = true }
        parser.on("-e OBJECT", "--extract OBJECT", "Extract OBJECT to a file.") { |tablename| extract = tablename }
        parser.on("-m NAME", "--match NAME", "NAME of OBJECT to be extracted.") { |tablename| extract = tablename }
        parser.invalid_option do |flag|
          invalid_options << flag
        end
      end

      # No arguments
      if !help && args.empty?
        STDERR.puts "mysqldumpsplitter: source file is required"
        STDERR.puts parser_output(parser), ""
        exit(1)
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

      if extract_object = extract
        operation = "extract"
        args.unshift(extract_object.as(String))
      end

      if describe
        operation = "describe"
      end

      args.unshift(operation)
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


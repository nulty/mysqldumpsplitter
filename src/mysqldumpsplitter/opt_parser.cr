require "option_parser"

module Mysqldumpsplitter
  module OptParser
    def parse_args(args : Array(String))
      help = true if args.any? { |arg| arg == "--help" }

      if args.any? && !args.last.starts_with?("-")
        source = args.last
      else
        source = ""
      end

      invalid_options = [] of String
      message = ""
      describe = false

      parser = OptionParser.parse(args) do |parser|
        parser.banner = "Usage: mysqldumpsplitter [arguments] source"
        parser.on("-h", "--help", "Show this help") { puts parser, "" }
        parser.on("-d", "--desc", "Describe the tables in the dump") { describe = true }
        parser.invalid_option do |flag|
          invalid_options << flag
        end
      end

      # print help and exit
      exit(0) if help

      # No arguments
      if args.empty?
        STDERR.puts "mysqldumpsplitter: source file is required"
        STDERR.puts parser, ""
        exit(1)
      end

      if !help
        if invalid_options.size == 1
          message += "mysqldumpsplitter: invalid option -- #{invalid_options.first}\n"
          STDERR.puts message, "" if !message.empty?
          exit(1)
        elsif invalid_options.size > 1
          puts parser, ""
          exit(1)
        end

        #unless source_file = File.open(source)
          #STDERR.puts "mysqldumpsplitter: #{source} is not a valid file"
          #exit(1)
        #end

        args
      end
    end
  end
end


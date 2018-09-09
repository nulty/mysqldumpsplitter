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

      parser = OptionParser.parse(args) do |parser|
        parser.banner = "Usage: mysqldumpsplitter [arguments] source"
        parser.on("-h", "--help", "Show this help") { help = true }
        parser.on("-d", "--desc", "Describe the tables in the dump") { describe = true }
        parser.invalid_option do |flag|
          invalid_options << flag
        end
      end

      # No arguments
      if !help && args.empty?
        STDERR.puts "mysqldumpsplitter: source file is required"
        STDERR.puts parser, ""
        exit(1)
      end

      if help
        puts parser, ""
        exit(0)
      else
        if invalid_options.size == 1
          message += "mysqldumpsplitter: invalid option -- #{invalid_options.first}\n"
          STDERR.puts message, "" if !message.empty?
          exit(1)
        elsif invalid_options.size > 1
          puts parser, ""
          exit(1)
        end

        args
      end
    end
  end
end


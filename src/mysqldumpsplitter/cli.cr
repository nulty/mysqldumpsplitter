require "./opt_parser"

module Mysqldumpsplitter
  class Cli
    include OptParser

    @operation : String
    @source : String
    @parsed_args : Hash(Symbol, String)

    def initialize(args)
      @parsed_args = parse_args(args)
      @operation = @parsed_args.fetch(:operation, "")
      @source = @parsed_args.fetch(:source, "")
    end

    def call
      source_validator
      execute(@operation)
    end

    def source_validator
      if !File.exists?(@source)
        STDERR.puts "File '#{@source}' doesn't exist"
        exit(2)
      end
    end

    def execute(op)
      case op
      when /desc/ then describe
      when /extract/ then extract
      end
    end

    def describe
      Mysqldumpsplitter::Describe.new(File.open(@source, "r")).call
    end

    def extract
      Mysqldumpsplitter::Extract.new(File.open(@source, "r"), @parsed_args).call
    end
  end
end

require "./opt_parser"

module Mysqldumpsplitter
  class Cli
    include OptParser

    def call(args)
      parse_args(args)
      args_validator(args)
      execute(args)
    end

    def args_validator(source)
      if !File.exists?(source.last)
        STDERR.puts "File '#{source.last}' doesn't exist"
        exit(2)
      end
    end

    def execute(source)
      Mysqldumpsplitter::Describe.new(File.open(source.last, "r")).call
    end
  end
end

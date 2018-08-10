require "../opt_parser"

module Mysqldumpsplitter
  class Cli
    include OptParser

    def parse(args)
      parse_args(args)
      args_validator(args)
    end


    def args_validator(source)
      puts source
      file_error = if File.exists?(source.last)
                      puts "File '#{source.last} exists!"
                    else
                      STDERR.puts "File '#{source.last}' doesn't exist"
                      exit(2)
                    end

    end
  end
end

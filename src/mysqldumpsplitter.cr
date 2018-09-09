require "./mysqldumpsplitter/*"

module Mysqldumpsplitter
end

Mysqldumpsplitter::Cli.new.call(ARGV)

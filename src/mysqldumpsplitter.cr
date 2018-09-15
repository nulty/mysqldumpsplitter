require "./mysqldumpsplitter/*"

module Mysqldumpsplitter
end

Mysqldumpsplitter::Cli.new(ARGV).call

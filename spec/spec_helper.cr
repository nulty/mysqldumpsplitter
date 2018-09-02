require "spec"
Root = File.expand_path("..", File.dirname(__FILE__))

ExecutablePath = File.expand_path("bin/mysqldumpsplitter", Root)
def path_from_root(path)
  File.expand_path(path,  File.dirname(__FILE__))
end

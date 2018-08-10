require "spec"
ExecutablePath = File.expand_path("../bin/mysqldumpsplitter", File.dirname(__FILE__))
def path_from_root(path)
  File.expand_path(path,  File.dirname(__FILE__))
end

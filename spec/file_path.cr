puts %Q{__FILE__},__FILE__
puts
puts %Q|File.expand_path("bin/mysqldumpsplitter", "..")|, File.expand_path("bin/mysqldumpsplitter", "..")
puts

puts %Q|File.expand_path("bin/mysqldumpsplitter", __FILE__)|, File.expand_path("bin/mysqldumpsplitter", __FILE__)
puts
puts %Q|File.expand_path("../bin/mysqldumpsplitter", File.dirname(__FILE__))|, File.expand_path("../bin/mysqldumpsplitter", File.dirname(__FILE__))



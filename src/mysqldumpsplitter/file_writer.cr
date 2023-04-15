require "compress/gzip"
class FileWriter

  def initialize(@file_name : String, @compression_type : String)
  end

  def self.open(file_name : String, compression_type : String, &block)
    case compression_type
    when /none/
      File.open("out/#{file_name}.sql", "w") do |f|
        yield f
      end
    when /gzip/
      File.open("out/#{file_name}.sql.gz", "w") do |f|
        Compress::Gzip::Writer.open(f) do |gzip|
          yield gzip
        end
      end
    end
  end

  def self.open(file_name : String, compression_type : String)
    case compression_type
    when /none/
      File.open("out/#{file_name}.sql", "w")
    when /gzip/
      f = File.new("out/#{file_name}.sql.gz", "w")
      Compress::Gzip::Writer.new(f)
    end
  end
end

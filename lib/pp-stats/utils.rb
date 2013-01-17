module PPStats
  module Utils
    def self.files_dotless(path)
      Dir.new(path).entries.reject { |f|  f =~ /^\./}
    end

    def self.files_recursive_nodirs(path)
      Dir.glob("#{path}/**/*").entries.reject { |f| File.directory? f }
    end
  end
end
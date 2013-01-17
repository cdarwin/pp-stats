require 'pathname'

module PPStats
  class Modules

    attr_reader :types

    def initialize(options)
      @options = options
      @types = ModuleTypes.instance.types
      @procssed_file = false
      @previous_line = nil
    end

    def run
      if @options[:single_module]
        process_module(@options[:modulepath])
      else
        PPStats::Utils.files_dotless(@options[:modulepath]).each do |file|
          file = File.join(@options[:modulepath], file)
          process_module file if File.directory? file
        end
      end

    end

    def results
      summary = PPStats::Summary.new(@types)
      summary.run
    end

    def process_module(moddir)
      puts PPStats::Format.green "module #{moddir}"
      @types.each_value do |type|
        puts PPStats::Format.blue "  #{type.dir}"
        process_type(moddir, type)
        puts if @procssed_file
      end
    end

    def process_type(moddir, type)
      @procssed_file = false
      return if !File.directory? moddir

      files = PPStats::Utils.files_recursive_nodirs(File.join(moddir, type.dir))
      files.each_with_index do |file, index|
        if filter_file(file, type)
          count, commented_count = process_file(file, index+1, files.length)
          type.counter.adjust(file, count, commented_count)
        end
      end
    end

    def filter_file(file, type)
      return true if type.file_exts == '*'
      type.file_exts.include? File.extname(file)
    end

    def process_file(path, index, totfiles)
      @procssed_file = true
      file = Pathname.new(path).basename
      line = "\r    #{file} (#{index}/#{totfiles})"
      STDOUT.write "\r" + " "*@previous_line.length if !@previous_line.nil?
      @previous_line = line
      STDOUT.write line
      STDOUT.flush
      lines = File.new(path).readlines
      commented_lines = lines.select { |line| line =~ /^#/ }
      sleep(0.05)
      return lines.count, commented_lines.count
    end

    class ModuleTypes
      require 'singleton'
      include Singleton

      attr_reader :types

      def initialize
        @types = {
            :pp => ModuleType.new('manifests', ['.pp']),
            :erb => ModuleType.new('templates', ['.erb']),
            :lib => ModuleType.new('lib', ['.rb']),
            :file => ModuleType.new('files', '*')
        }
      end

    end

    class ModuleType
      attr_reader :dir, :file_exts, :counter

      def initialize(dir, file_exts='*')
        @dir = dir
        @file_exts = file_exts
        @counter = PPStats::Counter.new
      end
    end

  end
end
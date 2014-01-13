require 'pathname'

module PPStats
  class Modules

    attr_reader :types, :module_count, :classes, :defines

    def initialize(options)
      @options = options
      @types = ModuleTypes.instance.types
      @procssed_file = false
      @previous_line = nil
      @module_count = 0
      @classes = 0
      @defines = 0
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
      summary = PPStats::Summary.new(@types, @module_count, @classes, @defines)
      summary.run
    end

    def process_module(moddir)
      puts PPStats::Format.green "module #{moddir}"
      @types.each do |k,v|
        puts PPStats::Format.blue "  #{k.to_s}"
        process_type(moddir, v)
        puts if @procssed_file
      end
      @module_count += 1
    end

    def process_type(moddir, type)
      @procssed_file = false
      return if !File.directory? moddir

      type.dirs.each do |dir|
        files = PPStats::Utils.files_recursive_nodirs(File.join(moddir, dir))
        files.each_with_index do |file, index|
          if filter_file(file, type)
            count, commented_count = process_file(file, index+1, files.length)
            type.counter.adjust(file, count, commented_count)
          end
        end
      end
    end

    def filter_file(file, type)
      ext = File.extname(file)
      if type.file_exts == '*'
        if ext =~ /\.\d/
          return false
        elsif type.exclude_exts.include? ext
          return false
        else
          return true
        end
      end
      type.file_exts.include? ext
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
      c = lines.select { |line| line =~ /^class/ }
      d = lines.select { |line| line =~ /^define/ }
      sleep(0.05)
      @classes += 1 if ! c.empty?
      @defines += 1 if ! d.empty?
      return lines.count, commented_lines.count
    end

    class ModuleTypes
      require 'singleton'
      include Singleton

      attr_reader :types

      def initialize
        @types = {
            :manifests   => ModuleType.new(['manifests'], ['.pp']),
            :templates   => ModuleType.new(['templates'], ['.erb']),
            :libraries   => ModuleType.new(['lib'], ['.rb']),
            :unit_tests  => ModuleType.new(['spec/classes',
                                          'spec/defines',
                                          'spec/functions',
                                          'spec/host',
                                          'spec/unit'],
                                         ['.rb']),
            :system_tests => ModuleType.new(['spec/system'], ['.rb']),
            #:file => ModuleType.new('files', '*')
        }
      end

    end

    class ModuleType
      attr_reader :dirs, :file_exts, :counter, :exclude_exts

      def initialize(dirs, file_exts='*')
        @dirs = dirs
        @file_exts = file_exts
        @counter = PPStats::Counter.new
        @exclude_exts = ['', '.png', '.exe', '.a']
      end
    end

  end
end

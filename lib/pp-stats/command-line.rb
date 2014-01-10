require 'optparse'

module PPStats
  class CommandLine

    def initialize(args)
    end

    def run
      options = {}
      optparse = OptionParser.new do |opts|
        opts.banner = "usage: pp-stats [options] modulepath"
        opts.on('--single-module', 'process a single module') do |flag|
          options[:single_module] = flag
        end
      end

      # Enforce required options and more graceful error handling.
      begin
        optparse.parse!
        # Not using required options anymore but I left it wired up.
        required = []
        missing = required.select { |param| options[param].nil? }
        if not missing.empty?
          PPStats::Format.errorf("missing options: #{missing.join(', ')}")
          exit
        end
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        PPStats::Format.errorf($!.to_s) # $! is exception object
        exit
      end

      if ARGV.first.nil?
        options[:modulepath] = '.'
      else
        options[:modulepath] = ARGV.first
      end
      if !File.directory? options[:modulepath]
        PPStats::Format.errorf "module folder '#{options[:modulepath]}' not found"
        exit
      end

      processor = PPStats::Processor.new(options)
      processor.run
      processor.results
    end


  end
end

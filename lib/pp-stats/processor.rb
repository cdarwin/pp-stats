module PPStats
  class Processor
    def initialize(options)
      @options = options
      @modules = PPStats::Modules.new(@options)
    end

    def run
      @modules.run
    end

    def results
      @modules.results
    end

  end
end
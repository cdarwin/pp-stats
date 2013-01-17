module PPStats
  class Summary
    def initialize(types)
      @types = types
    end

    def run
      puts PPStats::Format.cyan "-"*35
      @types.each_value do |type|
        puts PPStats::Format.cyan type.dir
        print_summary_line('files', type.counter.count[:files])
        print_summary_line('lines', type.counter.count[:lines])
        print_summary_line('max lines', "#{type.counter.count[:max_lines]} - #{type.counter.count[:max_file]}")
        print_summary_line('commented lines', type.counter.count[:commented_lines])
        print_summary_line('most commented', "#{type.counter.count[:max_commented_lines]} - #{type.counter.count[:max_commented_file]}")
        print_summary_line('least commented', "#{type.counter.count[:floor_commented_lines]} - #{type.counter.count[:floor_commented_file]}")
      end
    end

    def print_summary_line(label, data)
      printf "  %-20s #{data}\n", label
    end

  end
end
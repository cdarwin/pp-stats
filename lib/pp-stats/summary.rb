module PPStats
  class Summary
    def initialize(types, module_count, classes, defines)
      @types = types
      @module_count = module_count
      @classes = classes
      @defines = defines
    end

    def run
      puts PPStats::Format.cyan "-"*35
      @types.each do |k,v|
        puts PPStats::Format.cyan k.to_s
        print_summary_line('files', v.counter.count[:files])
        print_summary_line('lines', v.counter.count[:lines])
        print_summary_line('max lines', "#{v.counter.count[:max_lines]} - #{v.counter.count[:max_file]}")
        print_summary_line('commented lines', v.counter.count[:commented_lines])
        print_summary_line('most commented', "#{v.counter.count[:max_commented_lines]} - #{v.counter.count[:max_commented_file]}")
        print_summary_line('least commented', "#{v.counter.count[:floor_commented_lines]} - #{v.counter.count[:floor_commented_file]}")
      end
      puts PPStats::Format.cyan "-"*35
      puts PPStats::Format.cyan "Totals"
      print_summary_line('modules', "#{@module_count}")
      print_summary_line('classes', "#{@classes}")
      print_summary_line('defines', "#{@defines}")
    end

    def print_summary_line(label, data)
      printf "  %-20s #{data}\n", label
    end

  end
end

module PPStats
  class Counter
    attr_reader :count

    def initialize
      @count = {
          :files                  => 0,
          :lines                  => 0,
          :max_lines              => 0,
          :max_file               => nil,
          :floor_lines            => nil,
          :floor_file             => nil,
          :commented_lines        => 0,
          :max_commented_lines    => 0,
          :max_commented_file     => '',
          :floor_commented_lines  => 0,
          :floor_commented_file   => nil,
      }
    end

    def adjust(file, lines, commented_lines)
      @count[:files] += 1
      @count[:lines] += lines
      if lines > @count[:max_lines]
        @count[:max_lines] += lines
        @count[:max_file] = file
      end
      @count[:commented_lines] += commented_lines
      if commented_lines > @count[:max_commented_lines]
        @count[:max_commented_lines] = commented_lines
        @count[:max_commented_file] = file
      end
      if commented_lines < @count[:floor_commented_lines] || @count[:floor_commented_lines] == 0
        @count[:floor_commented_lines] = commented_lines
        @count[:floor_commented_file] = file
      end

    end

  end
end

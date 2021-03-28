# frozen_string_literal: true

module WTFChord
  class Keyboard
    FRAME = <<~EOF
    ┌─┬─┬┬─┬─┬─┬─┬┬─┬┬─┬─┐
    │ │ ││ │ │ │ ││ ││ │ │
    │ └┬┘└┬┘ │ └┬┘└┬┘└┬┘ │
    │  │  │  │  │  │  │  │
    └──┴──┴──┴──┴──┴──┴──┘
    EOF

    Key = Struct.new(:offset)
    class Key
      singleton_class.attr_accessor :select_symbol
      singleton_class.alias_method :[], :new

      def select(frame)
        frame[offset] = self.class.select_symbol
        frame
      end
    end

    W = Class.new(Key) { self.select_symbol = "▐▌" }
    B = Class.new(Key) { self.select_symbol = "█" }

    KEYS = {
      1  => W[70...72],
      2  => B[26...27],
      3  => W[73...75],
      4  => B[29...30],
      5  => W[76...78],
      6  => W[79...81],
      7  => B[35...36],
      8  => W[82...84],
      9  => B[38...39],
      10 => W[85...87],
      11 => B[41...42],
      12 => W[88...90]
    }

    def self.press(*positions)
      positions.each_with_object(FRAME.dup) do |pos, frame|
        KEYS.fetch(pos).select(frame)
      end
    end
  end
end

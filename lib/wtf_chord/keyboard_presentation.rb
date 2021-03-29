# frozen_string_literal: true

require 'wtf_chord/helpers/roman_numbers_helper'

module WTFChord
  class KeyboardPresentation
    FRAME = <<~EOF
    ┌─┬─┬┬─┬─┬─┬─┬┬─┬┬─┬─┐┬
    │ │ ││ │ │ │ ││ ││ │ ││
    │ └┬┘└┬┘ │ └┬┘└┬┘└┬┘ ││
    │  │  │  │  │  │  │  ││
    └──┴──┴──┴──┴──┴──┴──┘┴
     ↑                    |
     %s                    |
                          |
    EOF

    include RomanNumbersHelper

    KeyStruct = Struct.new(:index) do
      singleton_class.attr_accessor :mark
      singleton_class.alias_method :[], :new

      def call(frame)
        frame[index, mark.length] = mark
      end

      private def mark
        self.class.mark
      end
    end

    Key = -> (mark) { Class.new(KeyStruct).tap { |c| c.mark = mark } }
    W, B = Key["▐▌"], Key["█"]

    KEYS = [W[73], B[27], W[76], B[30], W[79], W[82], B[36], W[85], B[39], W[88], B[42], W[91]].
      map.with_index(1).to_h.invert.freeze

    def self.press(*positions)
      if positions.all? { |v| Integer === v }
        new.press(*positions)
      else
        positions.uniq(&:key).group_by(&:octave).inject(nil) do |a, (octave, strings)|
          pos = strings.map { |s| s.note.position }
          kb = new(octave).press(*pos)
          a.nil? ? kb : a + kb
        end
      end
    end

    attr_reader :frame

    def initialize(octave = 1)
      @octave = octave
      @frame = FRAME.dup % romanize(octave)
    end

    def +@
      shift!
      self
    end

    def +(other)
      pop!
      @frame.replace(@frame.lines(chomp: true).zip((+other).frame.lines).map(&:join).join)
      self
    end

    def press(*positions)
      positions.each { |pos| KEYS.fetch(pos).(@frame) }
      self
    end

    def to_s
      finalize!
    end

    def finalize!
      @frame.gsub("|", " ").gsub(/[^\s](?=\n)/, "")
    end

    def pop!
      @frame.replace(@frame.lines.each { |line| line[-3, 1] = "" }.join)
    end

    def shift!
      @frame.replace(@frame.lines.each { |line| line[0, 1] = "" }.join)
    end
  end
end

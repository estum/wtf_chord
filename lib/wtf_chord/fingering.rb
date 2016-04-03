require 'wtf_chord/fretboard'
require 'wtf_chord/complexity_counter'
require 'wtf_chord/formatter'

module WTFChord
  class Fingering < Fretboard
    def initialize(guitar)
      @capo      = guitar.capo
      @strings   = guitar.strings.map(&:dup)
      yield(self) if block_given?
    end

    def code
      @code ||= strings.map(&:code).pack("c*")
    end

    def == other
      case other
      when Fingering then other.code == code
      when Array     then other == @strings.map(&:fret)
      else super
      end
    end

    def complexity
      complexity_counter.rate
    end

    def draw
      Formatter.new(:default).call(self)
    end

    def set_fingers(fingers)
      fingers.each_with_index { |f, i| f.nil? ? @strings[i].dead : @strings[i].hold_on(f) }
    end

    def holded_strings
      @strings.select(&:holded?)
    end

    def used_strings
      @strings.reject(&:dead?)
    end

    def min_fret
      holded_strings.min.fret
    end

    private

    def complexity_counter
      @complexity_counter ||= ComplexityCounter.new(self)
    end
  end
end

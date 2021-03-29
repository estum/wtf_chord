require 'wtf_chord/fretboard'
require 'wtf_chord/complexity_counter'
require 'wtf_chord/formatter'

module WTFChord
  class Fingering < Fretboard
    attr_accessor :extra_complexity

    def initialize(guitar, fingers = nil)
      @capo      = guitar.capo
      @strings   = guitar.strings.map(&:dup)
      @extra_complexity = 0.0
      set_fingers(fingers) if fingers.is_a?(Array)
      yield(self) if block_given?
    end

    def code
      strings.map(&:code).pack("c*")
    end

    def == other
      case other
      when Fingering then other.code == code
      when Array     then other == @strings.map(&:fret)
      else super
      end
    end

    def eql?(other)
      super || self == other
    end

    def hash
      strings.map(&:code).hash
    end

    def used_keys
      used_strings.map(&:note).map(&:key).uniq.join
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

    def find_used_string_for(note)
      used = used_strings
      if idx = used.index(note)
        string = used[idx]
        yield(strings.index(string), string)
      end
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

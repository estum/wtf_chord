require 'wtf_chord/guitar_string'
require 'wtf_chord/drawer'

module WTFChord
  class Fingerboard
    attr_reader :strings, :capo

    def initialize(*strings)
      @capo    = 0
      @strings = strings.map! do |string|
        GuitarString.new(string, @capo)
      end
    end

    def [] idx
      case idx
      when 1..@strings.length then @strings[-idx]
      end
    end

    def set_capo(capo = 0)
      @capo = capo
      @strings.each do |string|
        string.set_capo(@capo)
      end
      self
    end

    def fingers
      strings.map { |string| string.dead? ? "×" : string.fret  }
    end

    def to_s
      "[ #{fingers * " "} ]"
    end

    def initialize_dup(other)
      super
      @strings = other.strings.map(&:dup)
      @code = nil
      @complexity = nil
    end

    def set_fingers(fingers)
      fingers.each_with_index do |f, i|
        f.nil? ? @strings[i].dead : @strings[i].hold_on(f)
      end
    end

    def with_fingers(*fingers)
      strings_was = @strings.dup
      set_fingers(fingers)
      yield(self)
      self
    ensure
      @strings = strings_was
    end

    def draw
      Drawer.new(self).draw
    end

    def count_holded_strings
      strings.count(&:holded?)
    end

    def holded_strings
      strings.select(&:holded?)
    end

    def used_strings
      strings.reject(&:dead?)
    end

    def inspect
      to_s
    end

    def code
      @code ||= strings.map(&:code).pack("c*")
    end

    def complexity
      @complexity ||= count_holded_strings * finger_dist
    end

    def finger_dist
      frets = holded_strings.map(&:fret)
      ((frets.max - frets.min).nonzero? || 1)
    end

    def min_fret
      holded_strings.map(&:fret).min
    end

    def == other
      case other
      when Fingerboard then other.code == code
      end
    end
  end
end

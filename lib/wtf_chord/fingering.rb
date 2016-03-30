require 'wtf_chord/fretboard'
require 'wtf_chord/complexity_counter'
require 'wtf_chord/drawer'

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
      other.is_a?(Fingering) ? other.code == code : super
    end

    def complexity
      complexity_counter.rate
    end

    def draw
      Drawer.new(self).draw
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

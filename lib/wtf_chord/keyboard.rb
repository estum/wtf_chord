# frozen_string_literal: true

require "wtf_chord/piano_key"

module WTFChord
  class Keyboard
    attr_reader :keys

    KEYS = %w(C C# D D# E F F# G G# A Bb B)

    def initialize(octaves = 1..5)
      @keys = octaves.to_a.product(KEYS).map { |(o, k)| PianoKey.new("#{k}#{o}") }
    end

    def [] idx
      case idx
      when 1..@keys.size then @keys[~-idx]
      end
    end
  end
end

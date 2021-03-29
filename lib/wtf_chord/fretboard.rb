# frozen_string_literal: true

require 'wtf_chord/guitar_string'

module WTFChord
  class Fretboard
    DEAD = "×"

    attr_reader :strings, :capo

    def initialize(*strings)
      @capo    = 0
      @strings = strings.map { |string| GuitarString.new(string, @capo) }
    end

    def [] idx
      case idx
      when 1..@strings.length then @strings[-idx]
      end
    end

    def set_capo(capo = 0)
      @capo = capo
      @strings.each { |string| string.set_capo(@capo) }
      self
    end

    def with_capo(capo)
      capo_was = @capo
      set_capo(capo)
      yield
    ensure
      set_capo(capo_was)
    end

    def fingers
      @strings.map { |string| string.dead? ? DEAD : string.fret  }
    end

    def to_s
      "[ #{fingers * " "} ]"
    end

    alias :inspect :to_s
  end
end

# frozen_string_literal: true

require "wtf_chord/instrument_pitch"

module WTFChord
  class PianoKey < InstrumentPitch
    def pressed?
      !!@pressed
    end

    def dead?
      !pressed?
    end

    def press!
      @pressed = true
    end
  end
end

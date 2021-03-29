# frozen_string_literal: true

require 'wtf_chord/pitch'

module WTFChord
  class InstrumentPitch < DelegateClass(Pitch)
    attr_reader :interval, :original

    def initialize(note)
      @original = WTFChord.note(note)
      super(init_pitch)
    end

    def init_pitch
      @original
    end

    def initialize_dup(other)
      super
      __setobj__(@original.dup)
    end

    def dead
    end

    def dead?
      raise NotImplementedError
    end

    def holded?
      raise NotImplementedError
    end

    def distance_to(pitch)
      pos = 0
      pos += 1 while (original + pos) != pitch
      pos
    end

    def code
      to_i
    end

    def <=> other
      case other
      when Integer
        to_i <=> other
      when InstrumentPitch
        to_i <=> other.to_i
      end
    end
  end
end

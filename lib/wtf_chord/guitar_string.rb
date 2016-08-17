require 'wtf_chord/pitch'

module WTFChord
  class GuitarString < DelegateClass(WTFChord::Pitch)
    attr_reader :capo, :fret, :original

    def initialize(note, capo = 0)
      @original = WTFChord.note(note)
      @fret = nil
      @capo = capo
      super(@original + capo)
    end

    def initialize_dup(other)
      super
      __setobj__(@original.dup)
    end

    def set_capo(capo)
      @capo = capo
      calculate_note!
    end

    def hold_on(fret)
      @fret = fret
      calculate_note!
    end

    def open
      @fret = 0
      calculate_note!
    end

    def dead
      @fret = nil
      calculate_note!
    end

    def dead?
      @fret.nil?
    end

    def holded?
      !dead? && @fret > 0
    end

    def code
      dead? ? -1 : to_i
    end

    def distance_to(pitch)
      pos = 0
      opened = dup.open
      pos += 1 while (opened + pos) != pitch
      pos
    end

    def <=> other
      return if dead?
      case other
      when Integer      then @fret <=> other
      when GuitarString then @fret <=> other.fret
      end
    end

    private

    def calculate_note!
      __setobj__(@original + @capo + (@fret || 0))
    end
  end
end

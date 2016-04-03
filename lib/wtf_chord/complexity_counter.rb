module WTFChord
  class ComplexityCounter
    def initialize(fingering)
      @fingering = fingering
    end

    def rate
      frets = @fingering.holded_strings.map(&:fret)
      barre = frets.uniq.keep_if { |o| frets.count(o) >= 2 }
      barre_strings = barre.min ? frets.count(barre.min).pred : 0

      base_rate = begin
        Rational(holded_strings - barre_strings, 4).to_f +
        Rational(finger_dist(@fingering.used_strings.map(&:fret)), 4).to_f
      end

      base_rate += 0.5 if (holded_strings - barre_strings) > 4

      # p [@fingering, holded_strings, barre_strings]

      if holded_strings > 4
        uniq_frets = frets.uniq.size

        if barre.size > 1 && uniq_frets == 3 && frets.count(barre.max) > barre_strings.next
          base_rate += 1 if complex_barre?(barre.max, frets)
        elsif barre_strings.next >= 2 || uniq_frets.size > 3
          base_rate += 1 if complex_barre?(barre.min, frets)
        end
      end

      base_rate
    end

    private

    def holded_strings
      @fingering.strings.count(&:holded?)
    end

    def total_strings
      @fingering.strings.size
    end

    def finger_dist(frets)
      (frets.max - frets.min).nonzero? || 1
    end

    def complex_barre?(barre, frets)
      return false unless barre
      barre > frets.min
    end
  end
end

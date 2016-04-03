module WTFChord
  class ComplexityCounter
    def initialize(fingering)
      @fingering = fingering
    end

    def rate
      frets = @fingering.holded_strings.map(&:fret)
      barre = frets.uniq.keep_if { |o| frets.count(o) >= 2 }.min
      barre_strings = barre ? frets.count(barre).pred : 0

      base_rate = begin
        Rational(holded_strings - barre_strings, 6).to_f +
        Rational(finger_dist(frets), 5).to_f
      end

      # p [@fingering, holded_strings, barre_strings]

      base_rate += 1 if (barre_strings > 2 || frets.uniq.size > 3) && complex_barre?(barre, frets)

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

module WTFChord
  class ComplexityCounter
    def initialize(fingering)
      @fingering = fingering
    end

    def rate
      frets = @fingering.holded_strings.map(&:fret)
      barre = frets.uniq.keep_if { |o| frets.count(o) > 3 }.max
      barre_strings = barre ? frets.count(barre).pred : 0

      base_rate = (
        Rational(holded_strings - barre_strings, total_strings) +
        Rational(finger_dist(frets), 5)
      ).to_f

      base_rate += 1 if complex_barre?(barre, frets)

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

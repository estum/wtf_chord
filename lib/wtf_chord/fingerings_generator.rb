module WTFChord
  class Chord
  end

  class FingeringsGenerator < DelegateClass(Chord)
    MAX_DIST = 5
    MAX_FRET = 7

    def fingerings
      @fingerings ||= []
    end

    def call
      fingerings.clear

      (0...MAX_FRET).each do |from|
        to = from + MAX_DIST
        generate(from...to) do |variant|
          fingerings << variant if filter_variant(variant)
        end
      end

      fingerings.sort_by!(&:complexity)
    end

    private

    def generate(fret_range)
      combinations = GUITAR.strings.map.with_index do |s, index|
        fret_range.select do |dist|
          pitch = s.original + dist
          has_note?(pitch)
        end.tap do |frets|
          frets << nil if frets.size == 0
        end
      end

      combinations.inject(&:product).each do |fingers|
        fingers.flatten!
        Fingering.new(GUITAR, fingers) do |variant|
          adjust(variant)
          yield(variant)
        end
      end
    end

    def filter_variant(variant)
      used_strings = variant.used_strings
      used_notes = used_strings.map(&:note)
      tones_count = notes.map { |n| used_notes.count(n) }

      !fingerings.include?(variant) &&
      basetone?(used_strings[0]) &&
      (third?(used_strings[1]) || third?(used_strings[2])) &&
      all_notes?(used_notes) &&
      used_notes.each_cons(2).none? { |(l, r)| l == r } &&
      tones_count.all? { |n| tones_count[0] >= n || tones_count[notes.index(third_tone)] >= n } &&
      variant.complexity <= 2.25
    end

    def adjust(fingering)
      while (string = fingering.used_strings[0]) && !basetone?(string)
        string.dead if !string.dead?
        break if fingering.used_strings.size == 4
      end
    end

    def all_notes?(used_notes)
      notes.all? { |n| used_notes.include?(n) }
    end

    def has_note?(value)
      value = value.note if !value.is_a?(Note) && value.respond_to?(:note)
      notes.include?(value)
    end

    def basetone?(string)
      string && string.note == notes[0]
    end

    def third?(string)
      string && (string.note == third_tone)
    end
  end
end

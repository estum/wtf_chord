# frozen_string_literal: true

module WTFChord
  module Collectors
    class Guitar < Generic
      self.max_dist = 5

      MAX_FRET = 7

      def collect!
        (0...MAX_FRET).each do |from|
          to = from + max_dist
          generate(from...to) do |variant|
            fingerings << set_bass(variant) if filter_variant(variant)
          end
        end

        fingerings.uniq!
        fingerings.sort_by!(&:complexity)
      end

      private

      def generate(fret_range)
        combinations = WTFChord.guitar.strings.map.with_index do |s, index|
          fret_range.
            select { |dist| pitch = s.original + dist; has_note?(pitch) }.
            tap    { |frets| frets << nil if frets.size == 0 }
        end

        combinations.inject(&:product).each do |fingers|
          fingers.flatten!

          Fingering.new(WTFChord.guitar, fingers) do |variant|
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
        (
          (third?(used_strings[1]) || third?(used_strings[2])) ||
          (last?(used_strings[1]) || last?(used_strings[2]))
        ) &&
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

      def set_bass(variant)
        if bass?
          variant.find_used_string_for(original_bass) do |idx, bass_string|
            try_set_bass_on(variant, idx) or begin
              4.times do |i|
                next if i == idx
                if try_set_bass_on(variant, i)
                  bass_string.dead
                  break
                end
              end
            end
          end
        end

        variant
      end

      def try_set_bass_on(variant, idx)
        bass_string = variant.strings[idx].dup
        distance = bass_string.distance_to(bass)

        if distance >= 0 && distance < 5 && (distance - variant.min_fret) > -3
          variant.extra_complexity += 0.5 if distance < variant.min_fret
          variant.strings[idx].hold_on(distance)
          true
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

      def last?(string)
        string && (string.note == notes[-1])
      end
    end
  end
end

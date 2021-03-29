# frozen_string_literal: true

module WTFChord
  module Collectors
    class Piano < Generic
      self.max_dist = 12
      MAX_OCTAVE = 5

      CheckDist = -> ((a, b)) { (a.to_i - b.to_i).abs <= max_dist }

      FilterProc = -> (actual_size, notes) {
        notes.uniq(&:key).size == actual_size && notes.sort.each_cons(2).all?(&CheckDist)
      }.curry(2).freeze

      Distances = -> (notes) {
        notes.each_cons(2).map { |(a, b)| (a.to_i - b.to_i).abs }
      }

      Sorting = -> (tone, notes) {
        notes = notes.sort
        mod = (notes[0].note.position - tone.position).abs.next
        score = Distances[notes[1..-1]].sum
        mod + score
      }.curry(2).freeze

      def collect!
        @keyboard = Keyboard.new(1..MAX_OCTAVE)

        @fingerings = @keyboard.keys.
          grep(__getobj__).
          combination(size).
          filter(&FilterProc[size])
        @fingerings.uniq! { |x| x.map(&:key) }
        @fingerings.sort_by!(&Sorting[tone])
        @fingerings
      end
    end
  end
end

# frozen_string_literal: true

module WTFChord
  class Chord
  end

  module Collectors
    class Generic < DelegateClass(Chord)
      singleton_class.attr_accessor :max_dist

      def fingerings
        @fingerings ||= []
      end

      def call
        reset!
        collect!
      end

      def reset!
        fingerings.clear
      end

      def collect!
        raise NotImplementedError
      end

      def max_dist
        self.class.max_dist
      end
    end
  end
end

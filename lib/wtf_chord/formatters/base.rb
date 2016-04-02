require 'forwardable'

module WTFChord
  module Formatters
    class Base
      FRETS = 6

      extend Forwardable
      def_delegators :@fret, :strings

      def self.separator
        "\n".freeze
      end

      def self.to_proc
        proc { |fret| new(fret).draw }
      end

      def initialize(fret)
        @fret = fret
      end

      def draw
      end

      protected

      def min_fret
        @min_fret = begin
          frets = strings.map(&:fret).tap(&:compact!)
          _min = frets.min.to_i || 1
          _min > 2 ? _min : 1
        end
      end
    end
  end
end

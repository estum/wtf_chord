# frozen_string_literal: true

require 'forwardable'

module WTFChord
  module Formatters
    class Base
      FRETS = 6

      extend Forwardable
      def_delegators :@fret, :strings

      def self.separator
        "\n"
      end

      def self.to_proc
        proc { |fret| new(fret, Thread.current[:with_rates]).draw }
      end

      def self.with_rates(value = false)
        Thread.current[:with_rates], with_rates_was = !!value, !!Thread.current[:with_rates]
        yield(self)
      ensure
        Thread.current[:with_rates] = with_rates_was
      end

      def initialize(fret, with_rates = false)
        @fret = fret
        @with_rates = !!with_rates
      end

      def draw
      end

      def actual_strings
        strings.reject(&:dead?)
      end

      def with_rates?
        !!@with_rates
      end

      protected

      def min_fret
        @min_fret = begin
          frets = strings.map(&:fret).tap(&:compact!)
          _min = frets.min.to_i || 1
          _min > 2 ? _min : 1
        end
      end

      private

      def rate
        "  complexity: %.2f" % @fret.complexity if with_rates?
      end
    end
  end
end

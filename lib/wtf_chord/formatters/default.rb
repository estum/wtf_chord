require 'wtf_chord/helpers/roman_numbers_helper'

module WTFChord
  module Formatters
    class Default < Base
      OPEN  = "|".freeze
      HORIZ = "—".freeze
      SPACE = "  ".freeze
      BULL  = "\u25C9".freeze
      NEWLINE = "\n".freeze
      COMPLEXITY_FORMAT = "  (complexity: %.2f)".freeze
      EMPTY_STRING = Array.new(FRETS, OPEN).freeze

      include RomanNumbersHelper

      def draw
        <<-EOF.gsub(/^\s+\|/, '')
          |[ #{head} ]  #{capo}
          | #{border}
          #{fret_rows.map.with_index { |row, index|
         "  |  #{row}  #{roman_min_fret if index == 0}"
          }.join("\n")}
          | #{border}
          |  #{string_keys}#{rate}
        EOF
      end

      private

      def head
        @fret.fingers * SPACE
      end

      def capo
        "(capo #{romanize(@fret.capo)})" if @fret.capo > 0
      end

      def roman_min_fret
        " ← #{romanize(min_fret)}" if min_fret > 1
      end

      def rate
        COMPLEXITY_FORMAT % @fret.complexity if with_rates?
      end

      def border
        @border ||= HORIZ * 3 * strings.length
      end

      def string_rows
        strings.map { |string| draw_string(string) }
      end

      def fret_rows
        return to_enum(__method__) unless block_given?
        string_rows.transpose.each { |row| yield(row * SPACE) }
      end

      def string_keys
        strings.map { |s| s.dead? ? SPACE : "%-2s" % s.key } * " "
      end

      def draw_string(string)
        EMPTY_STRING.dup.
          tap { |rows| rows[string.fret - min_fret] = BULL if string.holded? }
      end
    end
  end
end
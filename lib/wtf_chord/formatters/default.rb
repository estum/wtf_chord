module WTFChord
  module Formatters
    class Default < Base
      OPEN  = "|".freeze
      HORIZ = "–".freeze
      SPACE = "  ".freeze
      BULL  = "\u2022".freeze
      LATIN = %w(0 I II III IV V VI VII VIII IX X XII XIII).freeze
      NEWLINE = "\n".freeze

      def self.separator
        "\n\n".freeze
      end

      def draw
        [
          "[ #{head} ]#{capo}",
          " #{border}",
          *fret_rows,
          " #{border}",
          "  #{string_keys}"
        ] * NEWLINE
      end

      private

      def head
        @fret.fingers * SPACE
      end

      def capo
        "  (capo #{to_latin @fret.capo})" if @fret.capo > 0
      end

      def border
        @border ||= HORIZ * 3 * strings.length
      end

      def string_rows
        strings.map { |string| draw_string(string.fret) }
      end

      def fret_rows
        string_rows.transpose.map! { |row| "  #{row * SPACE}  " }.tap do |rows|
          rows[0] << "  #{to_latin min_fret}" if min_fret > 1
        end
      end

      def string_keys
        strings.map { |s| s.dead? ? SPACE : "%-2s" % s.key } * " "
      end

      def to_latin(num)
        LATIN[num]
      end

      def draw_string(fret)
        Array.new(FRETS, OPEN).tap do |rows|
          rows[(fret - min_fret.pred).pred] = BULL if fret.to_i > 0
        end
      end
    end
  end
end
# frozen_string_literal: true

require "wtf_chord/keyboard"

module WTFChord
  module Formatters
    class Piano < Base
      def draw
        [
          unique_notes.sort.join(" - "),
          Keyboard.press(*unique_notes.map(&:position))
        ].join("\n\n")
      end

      def unique_notes
        strings.reject(&:dead?).each_with_object([[], []]) do |string, (positions, notes)|
          unless positions.include?(string.note.position)
            positions << string.note.position
            notes << string.note
          end
        end[1]
      end
    end
  end
end

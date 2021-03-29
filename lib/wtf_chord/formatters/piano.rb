# frozen_string_literal: true

require "wtf_chord/formatters/piano1"
require "wtf_chord/keyboard"

module WTFChord
  module Formatters
    class Piano < Piano1
      def draw
        [
          pressed_keys.map(&:to_s).join(" - "),
          keyboard_presentation
        ].join("\n")
      end

      def keyboard_presentation
        KeyboardPresentation.press(*pressed_keys)
      end
    end
  end
end

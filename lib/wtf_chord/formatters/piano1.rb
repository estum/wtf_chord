# frozen_string_literal: true

require "wtf_chord/keyboard_presentation"

module WTFChord
  module Formatters
    class Piano1
      def self.separator
        "\n"
      end

      def self.to_proc
        proc { |keys| new(keys).draw }
      end

      def self.with_rates(*)
        yield(self)
      end

      attr_reader :pressed_keys

      def initialize(keys)
        @pressed_keys = keys
      end

      def draw
        [
          unique_notes.sort.join(" - "),
          keyboard_presentation
        ].join("\n\n")
      end

      def actual_notes
        actual_strings.map(&:note)
      end

      def unique_notes
        actual_notes.uniq(&:position)
      end

      def keyboard_presentation
        KeyboardPresentation.press(*unique_notes.map(&:position))
      end
    end
  end
end

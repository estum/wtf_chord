# frozen_string_literal: true

module WTFChord
  module RomanNumbersHelper
    ROMAN_SYMBOLS ||= ("\u2160".."\u216B").to_a.unshift(nil).freeze

    def romanize(number)
      ROMAN_SYMBOLS[number]
    end
  end
end

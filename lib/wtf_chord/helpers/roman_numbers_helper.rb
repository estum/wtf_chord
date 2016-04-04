module WTFChord
  module RomanNumbersHelper
    ROMAN_SYMBOLS ||= %w(I II III IV V VI VII VIII IX X XII XIII XIV XV XVI XVII).unshift(nil).freeze

    def romanize(number)
      ROMAN_SYMBOLS[number]
    end
  end
end

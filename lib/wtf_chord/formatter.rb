require 'wtf_chord/formatters/base'

module WTFChord
  class Formatter
    def initialize(name, with_rates = false)
      @name = name
      @with_rates = with_rates
      require_formatter! unless formatter?
    end

    def call(*fingerings)
      formatter.with_rates(@with_rates) { |f| fingerings.map(&f) }
    end

    alias :[] :call

    def separator
      formatter.separator
    end

    def formatter
      Formatters.const_get(formatter_name)
    end

    def formatter?
      Formatters.const_defined?(formatter_name)
    end

    def formatter_name
      @formatter_name ||= @name.gsub(/(?:^|_)([a-z\d]*)/i) { "#{$1.capitalize}" }.to_s.freeze
    end

    def require_formatter!
      require "wtf_chord/formatters/#{@name}"
    end
  end
end
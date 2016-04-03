require 'wtf_chord/formatters/base'

module WTFChord
  class Formatter
    def initialize(name, with_rates = false)
      @name = name
      @with_rates = with_rates
      require_formatter! unless formatter?
    end

    def call(*fingerings)
      formatter.with_rates(@with_rates) do |f|
        puts (fingerings.map(&f) * f.separator)
      end
    end

    alias :[] :call

    def formatter
      WTFChord::Formatters.const_get(formatter_name)
    end

    def formatter?
      WTFChord::Formatters.const_defined?(formatter_name)
    end

    def formatter_name
      @formatter_name ||= @name.gsub(/(?:^|_)([a-z\d]*)/i) { "#{$1.capitalize}" }.to_s.freeze
    end

    def require_formatter!
      require "wtf_chord/formatters/#{@name}"
    end
  end
end
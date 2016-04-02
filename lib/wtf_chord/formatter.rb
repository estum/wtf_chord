require 'wtf_chord/formatters/base'

module WTFChord
  class Formatter
    def initialize(name)
      @name = name
      require_formatter! unless formatter?
    end

    def call(*fingerings)
      puts (fingerings.map(&formatter) * formatter.separator)
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
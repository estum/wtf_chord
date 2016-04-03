module WTFChord
  class Note
    include Comparable

    attr_reader :key, :name, :position

    def initialize(key, position = nil)
      if /^(?<note>[a-h])(?<sign>#|b)?$/i =~ key
        note.upcase!
        @key      = "#{note}#{sign}".freeze
        @name     = "#{DIATONIC[note]}#{SIGNS[sign]}".freeze
        @position = position
      else
        raise ArgumentError
      end
    end

    def to_s
      @key.sub(/[b#]$/, SIGNS)
    end

    def inspect
      "#@name (#{to_s}: #@position)"
    end

    def == other
      case other
      when String  then other.casecmp(@key).zero?
      when Integer then other == @position
      when Note    then other.position == @position
      end
    end

    def <=> other
      case other
      when Note     then @position <=> other.position
      when Integer  then @position <=> other
      end
    end

    def aliases
      @aliases ||= SCALE.select { |t| t.position == @position && t.key != @key }
    end

    def semitone?
      @key.end_with?(FLAT, SHARP)
    end

    def with_octave(octave)
      Pitch.new(self, octave)
    end

    def chord(name)
      with_octave.chord(name)
    end

    alias :[] :with_octave
  end
end
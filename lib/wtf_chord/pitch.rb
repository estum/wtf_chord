require 'scanf'
require 'wtf_chord/note'
require 'forwardable'

module WTFChord
  class Pitch
    extend Forwardable
    include Comparable

    def_delegators :@note, :key
    attr_reader :note, :octave

    def initialize(note, octave = nil)
      raise ArgumentError unless note.is_a?(Note)

      @note   = note
      @octave = octave || 4
    end

    def to_str
      "#{@note.key}#{octave}"
    end

    def to_s
      "#{@note.to_s}#{octave}"
    end

    alias :inspect :to_s

    def move(amount)
      return self if amount.zero?

      to_octave, to_pos = (to_i + amount).divmod(12)

      if to_pos.zero?
        to_octave -= 1
        to_pos = 12
      end

      SCALE[to_pos][to_octave]
    end

    alias :+ :move

    def - amount
      move -amount
    end

    def to_i
      (@octave * 12) + @note.position
    end

    def == other
      case other
      when Integer, Pitch then other == to_i
      when String then other.casecmp(to_str).zero?
      when Note   then other == @note
      end
    end

    def <=> other
      case other
      when Note     then @note <=> other
      when Integer  then to_i  <=> other
      when Pitch    then to_i  <=> other.to_i
      end
    end

    def chord(name)
      Chord.new(self, name)
    end
  end

  NOTE_FSTR ||= "%2[A-Ha-h#b]%d".freeze

  def self.note(val)
    case val
    when String
      key, octave = val.scanf(NOTE_FSTR)
      SCALE[key][octave || 4] if key
    end
  end
end
require 'wtf_chord/fingering'
require 'wtf_chord/fingerings_generator'

module WTFChord
  class Chord
    BASS_MATCH = /(?<=[\\\/])[A-H][b#]?(?=$)/

    attr_reader :pitch, :steps, :notes, :name, :bass

    def initialize(note, name)
      @pitch = note.is_a?(Pitch) ? note : WTFChord.note(note)
      @name  = "#{@pitch.key}#{name}".freeze
      @steps = Array(WTFChord.rules[name])
      @notes = @steps.map { |dist| (@pitch + dist).note }.tap(&:uniq!)

      BASS_MATCH.match(@name) do |m|
        @bass = WTFChord.note(m[0]).note
      end
    end

    def fingerings(limit = nil)
      FingeringsGenerator.new(self).call[0, limit || 5]
    end

    def third_tone
      @third_tone ||= @notes[@steps.size > 3 ? 2 : -1]
    end

    def bass?
      !!@bass
    end

    def original_bass
      @notes[0]
    end

    def inspect
      "#{name} (#{@notes.map(&:key) * ' - '})"
    end
  end
end

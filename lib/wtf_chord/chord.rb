require 'wtf_chord/fingering'
require 'wtf_chord/fingerings_generator'

module WTFChord
  class Chord
    attr_reader :pitch, :steps, :notes, :name

    def initialize(note, name)
      @pitch = note.is_a?(Pitch) ? note : WTFChord.note(note)
      @name  = "#{@pitch.key}#{name}".freeze
      @steps = Array(WTFChord.rules[name])
      @notes = @steps.map { |dist| (@pitch + dist).note }.tap(&:uniq!)
    end

    def inspect
      "#{name} (#{@notes.map(&:key) * ' - '})"
    end

    def fingerings(limit = nil)
      limit ||= 5
      FingeringsGenerator.new(self).call[0, limit]
    end

    def third_tone
      @third_tone ||= @notes[@steps.index(7) || -1]
    end
  end
end

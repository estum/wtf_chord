module WTFChord
  class Chord
    MAX_DIST = 5
    MAX_FRET = 7

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

    def fingerings(limit = 3)
      list = []
      (0..MAX_FRET).each do |from_fret|
        fingering = get_fingering(from_fret)

        next if list.include?(fingering)

        if all_notes?(fingering.used_strings)
          list << fingering
        end
      end

      list.sort_by!(&:complexity)[0...limit].sort_by!(&:min_fret)
    end

    def draw_fingerings(limit = 3)
      puts (fingerings(limit).map(&:draw) * "\n\n")
    end

    def get_fingering(from_fret = 0)
      GUITAR.dup.tap do |guitar|
        guitar.strings.each do |s|
          fret = (from_fret..(from_fret+MAX_DIST)).detect { |dist| @notes.include?((s.original + dist).note) }
          fret ? s.hold_on(fret) : s.dead
        end

        while guitar.used_strings[0] && guitar.used_strings[0].note != @notes[0]
          guitar.used_strings.detect { |x| !x.dead? && x.note != @notes[0] }&.dead
        end
      end
    end

    def all_notes?(strings)
      snotes = strings.map(&:note).tap(&:uniq!)
      @notes.all? { |n| snotes.include?(n) }
    end
  end
end

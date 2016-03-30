require 'wtf_chord/fingering'

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
        f = get_fingering(from_fret)
        next if list.include?(f)
        list << f if all_notes?(f.used_strings)
      end

      list.sort_by!(&:complexity)[0...limit].sort_by!(&:min_fret)
    end

    def get_fingering(from_fret = 0)
      to_fret = from_fret + MAX_DIST
      Fingering.new(GUITAR) do |f|
        f.strings.each do |s|
          fret = (from_fret..to_fret).detect { |dist| @notes.include?((s.original + dist).note) }
          fret ? s.hold_on(fret) : s.dead
        end

        adjust_fingering(f.used_strings[0], to_fret, 0) while should_adjust?(f.used_strings[0], 0)
      end
    end

    def all_notes?(strings)
      snotes = strings.map(&:note).tap(&:uniq!)
      @notes.all? { |n| snotes.include?(n) }
    end

    def adjust_fingering(string, to_fret, i = 0)
      while string.fret < to_fret.pred
        string.hold_on(string.fret + 1)
        break if @notes.include?(string.note)
      end

      string.dead if !string.dead? && string.note != @notes[i]
    end

    def should_adjust?(string, i = 0)
      string && string.note != @notes[i]
    end

    def draw_fingerings(limit = 3)
      puts (fingerings(limit).map(&:draw) * "\n\n")
    end
  end
end

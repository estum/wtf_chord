require 'wtf_chord/note'
require 'wtf_chord/pitch'
require 'wtf_chord/fingerboard'

module WTFChord
  class ScaleArray < Array
    attr_reader :last_position

    def self.build(*list)
      tones = list.flat_map.with_index do |keys, position|
        keys.split("|").map! { |key| Note.new(key, position.next) }
      end
      new(tones)
    end

    def initialize(list)
      @last_position = list.map(&:position).sort![-1]
      super(list)
    end

    def [] idx
      case idx
      when 0       then nil
      when Integer then super(index(idx < 0 ? last_position + idx.next : idx))
      when String  then super(index(idx))
      else super
      end
    end
  end

  private_constant :ScaleArray

  FLAT    ||= "b".freeze
  SHARP   ||= "#".freeze
  SIGNS   ||= { FLAT => "\u266D".freeze, SHARP => "\u266F".freeze }.freeze

  DIATONIC = {
    "C" => "Do",
    "D" => "Re",
    "E" => "Mi",
    "F" => "Fa",
    "G" => "Sol",
    "A" => "La",
    "B" => "Si",
    "H" => "Si"
  }.freeze

  SCALE ||= begin
    chromatic_scale = %W(
      C
      C#|Db
      D
      D#|Eb
      E
      F
      F#|Gb
      G
      G#|Ab
      A
      Bb|A#
      B|H
    )
    ScaleArray.build(*chromatic_scale).freeze
  end

  GUITAR ||= Fingerboard.new(*%w(E2 A2 D3 G3 B3 E4))
end
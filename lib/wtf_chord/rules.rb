require 'yaml'
require 'wtf_chord/chord'

module WTFChord
  class Rules
    attr_reader :path, :chords, :extra, :pattern

    def initialize(path)
      @path = path
      rules = YAML.load_file(@path)
      @chords  = rules[:chords]
      @extra   = rules[:extra]
      @pattern = /
        (?<name>#{Regexp.union(@chords.keys.sort_by(&:length).reverse!)})?
        (?<ext>#{Regexp.union(@extra.keys.sort_by(&:length).reverse!)})?
      /x
    end

    def find(name = nil)
      steps = []
      name ||= ""

      name.match(pattern) do |m|
        base = chords[m[:name]] || chords["M"]
        steps.concat(base)
        steps.concat(extra[m[:ext]]) if m[:ext] && m[:ext].length <= (6 - steps.length)
      end

      steps.tap(&:uniq!)
    end

    alias :[] :find
  end

  def self.chord(name)
    name.match /^(?<note>[A-H][b#]?)(?<name>.+)?$/ do |m|
      Chord.new(m[:note], m[:name])
    end
  end
end
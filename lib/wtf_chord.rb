# frozen_string_literal: true

require "wtf_chord/scale"
require "wtf_chord/rules"
require "wtf_chord/version"

module WTFChord
  autoload :Fretboard, "wtf_chord/fretboard"
  autoload :Keyboard, "wtf_chord/keyboard"

  DEFAULTS = {
    :rules_file => File.expand_path("../wtf_chord.yml", __FILE__)
  }.freeze

  class << self
    attr_accessor :rules

    def config # :yields:
      yield(self)
    end

    def rules_file= value
      self.rules = Rules.new(File.expand_path(value))
    end

    def rules
      @rules ||= Rules.new(DEFAULTS[:rules_file])
    end
  end
end
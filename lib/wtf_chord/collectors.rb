# frozen_string_literal: true

require "wtf_chord/collectors/generic"

module WTFChord
  module Collectors
    autoload :Guitar, "wtf_chord/collectors/guitar"
    autoload :Piano,  "wtf_chord/collectors/piano"
  end
end

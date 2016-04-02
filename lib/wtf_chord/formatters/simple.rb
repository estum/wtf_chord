module WTFChord
  module Formatters
    class Simple < Base
      def draw
        "[ #{@fret.fingers * " "} ]"
      end
    end
  end
end

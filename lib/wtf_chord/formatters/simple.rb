module WTFChord
  module Formatters
    class Simple < Base
      def draw
        "[ #{@fret.fingers * " "} ]#{rate}"
      end
    end
  end
end

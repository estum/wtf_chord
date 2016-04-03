require 'spec_helper'

describe WTFChord::Fingering do
  let(:fingering) { WTFChord.chord("Em").fingerings[0] }

  it { expect(fingering).to have_attributes strings: ["E2", "B2", "E3", "G3", "B3", "E4"] }

  describe '#to_s' do
    it { expect(fingering.to_s).to eq "[ 0 2 2 0 0 0 ]" }
  end
end
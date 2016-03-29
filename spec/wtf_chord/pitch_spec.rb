require 'spec_helper'

describe WTFChord::Pitch do
  let(:pitch) { WTFChord.note("A5") }

  describe '#to_i' do
    it { expect(pitch.to_i).to eq 70 }
  end

  describe '#+' do
    it { expect(pitch + 1).to eq 'Bb5' }
    it { expect(pitch + 2).to eq 'B5' }
    it { expect(pitch + 3).to eq 'C6' }
  end

  describe '#-' do
    it { expect(pitch - 1).to eq 'G#5' }
    it { expect(pitch - 9).to eq 'C5' }
    it { expect(pitch - 10).to eq 'B4' }
  end
end
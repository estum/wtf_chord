require 'spec_helper'

describe WTFChord do
  it 'has a version number' do
    expect(WTFChord::VERSION).not_to be nil
  end

  describe '.note' do
    it { expect(WTFChord.note('C5')).to eq "C5" }
  end
end

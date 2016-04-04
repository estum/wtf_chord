require 'spec_helper'

describe WTFChord::Note do
  context "Note Si having aliases in different notation styles" do
    subject { WTFChord.note("B").note }

    it { is_expected.to eq "B" }
    it { is_expected.to eq "H" }
    it { is_expected.not_to eq "Bb" }
  end
end
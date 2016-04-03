require 'spec_helper'

describe WTFChord::Pitch do
  shared_examples "for a note" do |name, pitch, operations|
    context "A pitch ‘#{name}’" do
      subject { WTFChord.note(name) }

      it { is_expected.to eq pitch }

      describe "#to_s" do
        it { expect(subject.to_s).to eq name }
      end

      operations.each do |change, note|
        it "#{change > 0 ? '+' : '-'} #{change.abs} = #{note}" do
          expect(subject + change).to eq note
        end
      end
    end
  end

  include_examples "for a note", "A5", 70,
    1  => 'Bb5', 2  => 'B5', 3   => 'C6',
    -1 => 'G#5', -9 => 'C5', -10 => 'B4'
end
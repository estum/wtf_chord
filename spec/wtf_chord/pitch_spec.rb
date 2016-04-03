require 'spec_helper'

describe WTFChord::Pitch do
  shared_examples "for a note" do |name, value, operations|
    context "A pitch ‘#{name}’" do
      let(:pitch) { WTFChord.note(name) }

      it { expect(pitch).to eq value }

      describe "#to_s" do
        it { expect(pitch.to_s).to eq name }
      end

      operations.each do |change, note|
        it "#{change > 0 ? '+' : '-'} #{change.abs} = #{note}" do
          expect(pitch + change).to eq note
        end
      end
    end
  end

  include_examples "for a note", "A5", 70,
    1  => 'Bb5', 2  => 'B5', 3   => 'C6',
    -1 => 'G#5', -9 => 'C5', -10 => 'B4'
end
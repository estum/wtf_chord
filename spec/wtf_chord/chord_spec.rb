require 'spec_helper'

describe WTFChord::Chord do
  shared_examples "for a chord" do |name, params|
    subject { WTFChord.chord(name) }

    context "A chord ‘#{name}’" do
      it "has correct steps" do
        expect(subject.steps).to eq params[:steps]
      end

      it "has correct notes" do
        expect(subject.notes).to eq params[:notes]
      end

      it "generates correct fingerings" do
        expect(subject.fingerings).to include(*params[:fingerings])
      end
    end
  end

  include_examples "for a chord", "Em",
    :steps      => [0, 3, 7],
    :notes      => ["E", "G", "B"],
    :fingerings => [[0, 2, 2, 0, 0, 0],
                    [nil, nil, 2, 4, 5, 3]]

  include_examples "for a chord", "D7",
    :steps => [0, 4, 7, 10]
    :notes => ["D", "F#", "A", "C"],
    :fingerings => [[nil, nil, 0, 2, 1, 2],
                    [nil, 5, 7, 5, 7, 5]]
end
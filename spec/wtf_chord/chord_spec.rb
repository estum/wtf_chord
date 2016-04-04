require 'spec_helper'

describe WTFChord::Chord do
  shared_examples "for a chord" do |chords|
    chords.each do |name, params|
      context "A chord ‘#{name}’" do
        let(:chord) { WTFChord.chord(name) }

        it "has correct steps" do
          expect(chord.steps).to eq params[:steps]
        end

        it "has correct notes" do
          expect(chord.notes).to eq params[:notes]
        end

        it "generates correct fingerings" do
          expect(chord.fingerings).to include(*params[:fingerings])
        end
      end
    end
  end

  include_examples "for a chord",
    "Em" => {
      :steps      => [0, 3, 7],
      :notes      => %w(E G B),
      :fingerings => [[0, 2, 2, 0, 0, 0],
                      [nil, nil, 2, 4, 5, 3]]
    },
    "D7" => {
      :steps => [0, 4, 7, 10],
      :notes => %w(D F# A C),
      :fingerings => [[nil, nil, 0, 2, 1, 2],
                      [nil, 5, 7, 5, 7, 5]]
    },
    "B7" => {
      :steps => [0, 4, 7, 10],
      :notes => %w(B D# F# A),
      :fingerings => [[nil, 2, 1, 2, 0, 2],
                      [nil, 2, 4, 2, 4, 2],
                      [  7, 9, 7, 8, 7, 7]]
    }
end
require 'journey'

describe Journey do
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  subject(:journey) { described_class.new(entry_station) }

  it "knows if a journey is not complete" do
    expect(journey).not_to be_complete
  end

  it 'has a penalty fare by default' do
    expect(journey.fare).to eq described_class::PENALTY_FARE
  end

  it "returns itself when exiting a journey" do
    expect(journey.finish(exit_station)).to eq(journey)
  end

  context 'given an entry station' do

    it 'has an entry station' do
      expect(journey.entry_station).to eq entry_station
    end

    it "returns a penalty fare if no exit station given" do
      expect(journey.fare).to eq described_class::PENALTY_FARE
    end

    context 'given an exit station' do
      let(:other_station) { double :other_station }

      before do
        journey.finish(other_station)
      end

      it 'calculates a fare' do
        expect(journey.fare).to eq described_class::MINIMUM_CHARGE
      end

      it "knows if a journey is complete" do
        expect(journey).to be_complete
      end
    end
  end
end

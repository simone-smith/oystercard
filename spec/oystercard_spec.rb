require 'oystercard'

describe Oystercard do

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  describe '#initialize' do
    it 'initializes with a balance of 0' do
      expect(subject.balance).to eq 0
    end

    it 'has an empty list of journeys by default' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#top_up' do
    it 'tops up the card with money' do
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

    it 'throws an exception when balance goes above 90' do
      maximum_balance = described_class::MAX_BALANCE
      subject.top_up(maximum_balance)
      expect { subject.top_up 1 }.to raise_error("Maximum balance of #{described_class::MAX_BALANCE} exceeded")
    end
  end

  it 'is initially not in a journey' do
    expect(subject).not_to be_in_journey
  end

  describe '#in_journey?' do
    it 'returns true or false' do
      expect(subject.in_journey?).to be(true).or be(false)
    end
  end

  context 'when there is not enough money on the card' do
    describe '#touch_in' do
      it 'raises an error if insufficient funds to travel' do
        expect { subject.touch_in }.to raise_error("Insufficient funds")
      end
    end
  end

  context 'when there is money on the card' do
    let(:journeys){ {entry_station: entry_station, exit_station: exit_station} }

    before { subject.top_up(described_class::BALANCE_LIMIT) }

    it 'stores a journey' do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to eq ({entry_station => exit_station})
    end

    describe '#touch_in' do
      it 'starts a journey' do
        subject.touch_in(entry_station)
        expect(subject).to be_in_journey
      end

      it 'remembers the entry station after touch_in' do
        subject.touch_in(entry_station)
        expect(subject.entry_station).to eq entry_station
      end
    end
  end

  context 'when oystercard is already in a journey' do
    before { subject.top_up(described_class::BALANCE_LIMIT) }
    before { subject.touch_in(entry_station) }

    describe '#touch_out' do
      it 'ends a journey' do
        subject.touch_out
        expect(subject).not_to be_in_journey
      end

      it 'charges card on touchout' do
        expect { subject.touch_out }.to change { subject.balance }.by -described_class::MINIMUM_CHARGE
      end

      it 'stores exit station' do
        subject.touch_out(exit_station)
        expect(subject.exit_station).to eq exit_station
      end
    end
  end
end

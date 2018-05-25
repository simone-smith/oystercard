require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  describe '#initialize' do
    it 'initializes with a balance of 0' do
      expect(oystercard.balance).to eq 0
    end

    it 'has an empty list of journeys by default' do
      expect(oystercard.journeys).to be_empty
    end
  end

  describe '#in_journey?' do
    it 'returns true or false' do
      expect(oystercard.in_journey?).to be(true).or be(false)
    end
  end

  context 'when not in a journey' do

    it 'is initially not in a journey' do
      expect(oystercard).not_to be_in_journey
    end

    describe '#top_up' do
      it 'tops up the card with money' do
        expect { oystercard.top_up 1 }.to change { oystercard.balance }.by 1
      end

      it 'throws an exception when balance goes above 90' do
        maximum_balance = described_class::MAX_BALANCE
        oystercard.top_up(maximum_balance)
        expect { oystercard.top_up 1 }.to raise_error("Maximum balance of #{described_class::MAX_BALANCE} exceeded")
      end
    end
  end

  context 'when in a journey' do
    context 'when there is money on the card' do
      let(:journey){ { entry_station: entry_station, exit_station: exit_station } }
      before { oystercard.top_up(described_class::BALANCE_LIMIT) }

      it 'stores a journey' do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.journeys).to include journey
      end

      describe '#touch_in' do
        before { oystercard.touch_in(entry_station) }
        it 'starts a journey' do
          expect(oystercard).to be_in_journey
        end

        it 'remembers the entry station after touch_in' do
          expect(oystercard.entry_station).to eq entry_station
        end
      end

      describe '#touch_out' do
        before { oystercard.touch_in(entry_station) }
        it 'ends a journey' do
          oystercard.touch_out(exit_station)
          expect(oystercard).not_to be_in_journey
        end

        it 'charges card on touchout' do
          expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -(described_class::MINIMUM_CHARGE)
        end

        it 'stores exit station' do
          oystercard.touch_out(exit_station)
          expect(oystercard.exit_station).to eq exit_station
        end
      end
    end

    context 'when not touched in' do
      it 'does not raise an error on touch out' do
        oystercard.top_up(10)
        expect { oystercard.touch_out(exit_station) }.not_to raise_error
      end

      it 'deducts a penalty fare' do
        oystercard.top_up(10)
        expect { oystercard.touch_out(exit_station) }.to change {oystercard.balance}.by -(described_class::PENALTY_FARE)
      end
    end

    context 'when not touched out' do
      it 'does not raise an error when touched in' do
        oystercard.top_up(10)
        oystercard.touch_in(entry_station)
        expect { oystercard.touch_in(entry_station) }.not_to raise_error
      end

      it 'deducts a penalty fare when touched in' do
        oystercard.top_up(10)
        oystercard.touch_in(entry_station)
        expect { oystercard.touch_in(entry_station) }.to change {oystercard.balance}.by -(described_class::PENALTY_FARE)
      end
    end

    context 'when there is not enough money on the card' do
      describe '#touch_in' do
        it 'raises an error if insufficient funds to travel' do
          expect { oystercard.touch_in(entry_station) }.to raise_error("Insufficient funds")
        end
      end
    end
  end
end

require 'oystercard'

describe Oystercard do
  describe '#initialize' do
    it 'initializes with a balance of 0' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'tops up the card with monies' do
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

    it 'throws an exception when balance goes above 90' do
      maximum_balance = described_class::MAX_BALANCE
      subject.top_up(maximum_balance)
      expect { subject.top_up 1 }.to raise_error("Maximum balance of #{described_class::MAX_BALANCE} exceeded")
    end

  end

  describe '#deduct' do
    it 'reduces the balance by a specified amount' do
      expect { subject.deduct 1 }.to change { subject.balance }.by -1
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

  context 'there is money on the card' do
    before { subject.top_up(described_class::BALANCE_LIMIT) }
    describe '#touch_in' do
      it 'starts a journey' do
        subject.touch_in
        expect(subject).to be_in_journey
      end
    end

    describe '#touch_out' do
      it 'ends a journey' do
        subject.touch_in
        subject.touch_out
        expect(subject).not_to be_in_journey
      end
    end
  end


end

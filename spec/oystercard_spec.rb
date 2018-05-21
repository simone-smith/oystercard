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

end

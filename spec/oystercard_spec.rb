require 'oystercard'

describe Oystercard do
  describe '#initialize' do
    it 'initializes with a balance of 0' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'tops up the card with monies' do
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end
  end

end

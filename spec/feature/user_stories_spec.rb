describe 'user stories' do
  # In order to be charged correctly
  # As a customer
  # I need a penalty charge deducted if I fail to touch in or out
  it 'deducts a charge if I fail to touch in' do
    card = Oystercard.new
    card.top_up(10)
    expect { card.touch_out("Edgware")}.to change {card.balance}.by -6
  end

  it 'deducts a charge if I fail to touch out' do
    card = Oystercard.new
    card.top_up(10)
    card.touch_in("Edgware")
    expect { card.touch_in("Edgware") }.to change {card.balance}.by -6
  end
end

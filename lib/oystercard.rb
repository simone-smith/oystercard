class Oystercard
  attr_reader :balance, :entry_station
  MAX_BALANCE = 90
  BALANCE_LIMIT = 1
  MINIMUM_CHARGE = 3

  def initialize
    @balance = 0
  end

  def top_up(amount)
    fail "Maximum balance of #{MAX_BALANCE} exceeded" if (@balance + amount) > MAX_BALANCE
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(entry_station = nil)
    fail "Insufficient funds" if @balance < BALANCE_LIMIT
    @entry_station = entry_station
  end

  def entry_station
    @entry_station
  end

  def touch_out
    deduct(MINIMUM_CHARGE)
    @entry_station = nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end

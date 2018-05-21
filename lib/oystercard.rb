class Oystercard
  attr_reader :balance
  MAX_BALANCE = 90
  BALANCE_LIMIT = 1
  MINIMUM_CHARGE = 3

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    fail "Maximum balance of #{MAX_BALANCE} exceeded" if (@balance + amount) > MAX_BALANCE
    @balance += amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    fail "Insufficient funds" if @balance < BALANCE_LIMIT
    @in_journey = true
  end

  def touch_out
    deduct(MINIMUM_CHARGE)
    @in_journey = false
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end

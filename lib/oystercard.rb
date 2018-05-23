class Oystercard
  attr_reader :balance, :entry_station, :exit_station, :journeys
  MAX_BALANCE = 90
  BALANCE_LIMIT = 1
  MINIMUM_CHARGE = 3

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    fail "Maximum balance of #{MAX_BALANCE} exceeded" if (@balance + amount) > MAX_BALANCE
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(entry_station)
    fail "Insufficient funds" if @balance < BALANCE_LIMIT
    @entry_station = entry_station
    journeys << {entry_station: entry_station, exit_station: nil}
  end

  def touch_out(exit_station)
    deduct(MINIMUM_CHARGE)
    @exit_station = exit_station
    journeys.last[:exit_station] = exit_station
    @entry_station = nil
    @exit_station
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end

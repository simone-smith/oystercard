require_relative 'station'
require_relative 'journey'

class Oystercard
  attr_reader :balance, :entry_station, :exit_station, :journeys
  MAX_BALANCE = 90
  BALANCE_LIMIT = 1
  MINIMUM_CHARGE = 3
  PENALTY_FARE = 6

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

    if !journeys.empty? && journeys.last[:exit_station] == nil #refactor - set last journey's exit station as unknown
      deduct(PENALTY_FARE)
    end
      journeys << { entry_station: entry_station, exit_station: nil }
  end

  def touch_out(exit_station)
    @exit_station = exit_station
    if first_journey_not_touched_in(journeys) || not_touched_in_but_not_first_journey(journeys)
      journeys << { entry_station: "unknown", exit_station: exit_station }
      deduct(PENALTY_FARE)
    else
      journeys.last[:exit_station] = exit_station
      deduct(MINIMUM_CHARGE)
    end
    @entry_station = nil
    @exit_station
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def first_journey_not_touched_in(journey)
    journeys.empty?
  end

  def not_touched_in_but_not_first_journey(journey)
    journeys.last[:exit_station] != nil
  end
end

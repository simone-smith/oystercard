require 'oystercard'

class Journey
  attr_reader :entry_station, :exit_station, :complete_journey
  MINIMUM_CHARGE = 3
  PENALTY_FARE = 6

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @exit_station = nil
  end

  def finish(exit_station)
    @exit_station = exit_station
    return self
  end

  def fare
    complete? ? MINIMUM_CHARGE : PENALTY_FARE
  end

  def complete?
    entry_station && exit_station
  end

end

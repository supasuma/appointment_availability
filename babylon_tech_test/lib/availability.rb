class Availability

  attr_reader :appointments, :booked_appointments

  def initialize(appointments, booked_appointments)
    @appointments = appointments
    @booked_appointments = booked_appointments
  end


end

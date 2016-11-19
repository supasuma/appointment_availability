class Availability

  attr_reader :appointments, :booked_appointments

  def initialize(appointments, booked_appointments)
    @appointments = appointments
    @booked_appointments = booked_appointments
  end

  def find_availability(request)
    avail_appt = appointments.select {|appt| appt['time'] == request }
    !avail_appt.empty? ? book_appointment(avail_appt) : next_avail_appt(request)
  end

  private

  def book_appointment(avail_appt)
    booked_appointments << avail_appt[0]
    appointments.delete(avail_appt[0])
    return avail_appt[0]["time"]
  end


end

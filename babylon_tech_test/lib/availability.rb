class Availability

  TIME_FORMAT = "%H:%M:%S"
  ADD_TEN_MINS = 600
  CLINIC_CLOSED = "15:00:00"

  attr_reader :appointments

  def initialize(appointments)
    @appointments = appointments
  end

  def find_availability(request)
    no_appts_avail? ? "No appointments available" : select_available_appt(request)
  end

  private

  def select_available_appt(request)
    avail_appt = appointments.select {|appt| appt['time'] == request }
    !avail_appt.empty? ? book_appointment(avail_appt) : next_avail_appt(request)
  end

  def book_appointment(avail_appt)
    appointments.delete(avail_appt[0])
    return avail_appt[0]["time"]
  end

  def next_avail_appt(request)
    return "There are no appointments after 3pm" unless Time.parse(request) < Time.parse(CLINIC_CLOSED)
    request = (Time.parse(request) + ADD_TEN_MINS).strftime(TIME_FORMAT)
    find_availability(request)
  end

  def no_appts_avail?
    appointments.empty?
  end


end

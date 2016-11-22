class Availability

  TIME_FORMAT = "%H:%M:%S"
  ADD_TEN_MINS = 600
  CLINIC_CLOSED = "15:01:00"

  attr_reader :appointments

  def initialize(appointments)
    @appointments = appointments
  end

  def find_availability(request)
    no_appts_avail? ? nil : select_available_appt(request)
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
    if Time.parse(request) > Time.parse(CLINIC_CLOSED)
       nil
    else
      request = (Time.parse(request) + ADD_TEN_MINS).strftime(TIME_FORMAT)
      find_availability(request)
    end
  end

  def no_appts_avail?
    appointments.empty?
  end

end

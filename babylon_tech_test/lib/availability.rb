class Availability

  TIME_FORMAT = "%H:%M:%S"

  attr_reader :appointments

  def initialize(appointments)
    @appointments = appointments
  end

  def find_availability(request)
    if no_appts_avail?
      return "There are no appointments available today"
    else
      avail_appt = appointments.select {|appt| appt['time'] == request }
      !avail_appt.empty? ? book_appointment(avail_appt) : next_avail_appt(request)
    end
  end

  private

  def book_appointment(avail_appt)
    appointments.delete(avail_appt[0])
    return avail_appt[0]["time"]
  end

  def next_avail_appt(request)
    return "There are no appointments after 3pm" unless Time.parse(request) < Time.parse("15:00:00")
    request = (Time.parse(request) + 600).strftime(TIME_FORMAT)
    find_availability(request)
  end

  def no_appts_avail?
    appointments.empty?
  end


end

require 'availability'

describe Availability do
  subject(:availability) { described_class.new(appointments, booked_appointments) }

  let(:booked_appointments) { [] }
  let(:appointments) { [{"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>1},
                        {"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>2},
                        {"time"=>"08:10:00", "slot_size"=>10, "doctor_id"=>1},
                        {"time"=>"08:20:00", "slot_size"=>10, "doctor_id"=>1}]
                      }
  let(:booked_appointment) { [{"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>1}] }

  it "has a list of available appointments" do
    expect(availability.appointments).to eq appointments
  end

  it "has a list of booked appointments" do
    expect(availability.booked_appointments).to eq booked_appointments
  end

  it "is able to book an available appointment" do
    availability.find_availability("08:00:00")
    expect(availability.booked_appointments).to eq booked_appointment
  end

  it "won't book the same appointment twice" do
    booked_appointments = [{"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>1},
                          {"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>2}]
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
    expect(availability.booked_appointments).to eq booked_appointments
  end

  it "if appointment unavailable it will book the next available" do
    booked_appointments = [{"time"=>"08:10:00", "slot_size"=>10, "doctor_id"=>1},
                          {"time"=>"08:20:00", "slot_size"=>10, "doctor_id"=>1}]
    availability.find_availability("08:10:00")
    availability.find_availability("08:10:00")
    expect(availability.booked_appointments).to eq booked_appointments
  end

  it "won't book an appointment before 8am but will find earliest available" do
    availability.find_availability("07:10:00")
    expect(availability.booked_appointments).to eq booked_appointments
  end

  it "won't book an appointment after 3pm" do
    availability.find_availability("16:10:00")
    expect(availability.booked_appointments).to eq []
  end

  it "won't book at appointment with an incorrect time interval" do
    availability.find_availability("07:15:00")
    expect(availability.booked_appointments).to eq []
  end

  it "will return a message if no appointments are available" do
    book_all_available_slots
    expect(availability.find_availability("08:00:00")).to eq "There are no appointments available today"
  end

  def book_all_available_slots
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
  end

end

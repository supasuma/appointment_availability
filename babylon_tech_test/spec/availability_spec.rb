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

end

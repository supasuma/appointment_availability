require 'availability'

describe Availability do
  subject(:availability) { described_class.new(appointments) }

  let(:appointments) { [{"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>1},
                        {"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>2},
                        {"time"=>"08:10:00", "slot_size"=>10, "doctor_id"=>1},
                        {"time"=>"08:20:00", "slot_size"=>10, "doctor_id"=>1}]
                      }
  let(:booked_appointment) { [{"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>1}] }
  let(:booked_appointments) { [{"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>1},
                              {"time"=>"08:00:00", "slot_size"=>10, "doctor_id"=>2}]
                            }
  let(:booked_appointments2) { [{"time"=>"08:10:00", "slot_size"=>10, "doctor_id"=>1},
                                {"time"=>"08:20:00", "slot_size"=>10, "doctor_id"=>1}]
                              }

  it "has a list of available appointments" do
    expect(availability.appointments).to eq appointments
  end

  it "is able to book an available appointment" do
    availability.find_availability("08:00:00")
    expect(availability.appointments).not_to include booked_appointment
  end

  it "won't book the same appointment twice for same doctor" do
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
    expect(availability.appointments).not_to include booked_appointments
  end

  it "if an appointment is unavailable it will book the next available" do
    availability.find_availability("08:10:00")
    availability.find_availability("08:10:00")
    expect(availability.appointments).not_to include booked_appointments2
  end

  it "won't book an appointment before 8am but will find earliest available" do
    availability.find_availability("07:10:00")
    expect(availability.appointments).not_to include booked_appointment
  end

  it "won't book an appointment after 3pm" do
    availability.find_availability("16:10:00")
    expect(availability.appointments).to eq appointments
  end

  it "won't book an appointment with an incorrect time interval" do
    availability.find_availability("07:15:00")
    expect(availability.appointments).to eq appointments
  end

  it "will return a message if TIME_FORMAT_CHECKtments are available" do
    book_all_available_slots
    expect(availability.find_availability("08:00:00")).to eq nil
  end

  def book_all_available_slots
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
    availability.find_availability("08:00:00")
  end

end

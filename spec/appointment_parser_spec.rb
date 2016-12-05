require 'appointment_parser'

describe AppointmentParser do

    subject(:appointment_parser) { described_class.new('spec/json_test_file_2.json') }

    after(:each) do
        IO.copy_stream('spec/json_test_file_1.json', 'spec/json_test_file_2.json')
    end

    amended_slots = {
       "availability_slots":[
         {
            "time":"08:20:00",
            "slot_size":10,
            "doctor_id":1
          }
        ]
       }


    it "alters json file to accomodate changes to availability after bookings" do
      appointment_parser.update_json('json_test_file.json', amended_slots)
      new_json = "{\n  \"availability_slots\": [\n    {\n      \"time\": \"08:20:00\",\n      \"slot_size\": 10,\n      \"doctor_id\": 1\n    }\n  ]\n}"
      expect(File.read('json_test_file.json')).to eq(new_json)
    end

  end

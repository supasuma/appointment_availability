
require_relative 'appointment_parser'
require 'json'

class Availability
    # TIME_FORMAT = '%H:%M:%S'.freeze
    # ADD_TEN_MINS = 600
    # CLINIC_CLOSED = '15:01:00'.freeze

    attr_reader :appointments, :appointment_hash, :json_file

    def initialize(json_file)
        @json_file = json_file
        @appointment_hash = Appointment_parser.new(json_file)
        @appointments = appointment_hash.slots['availability_slots']
    end

    def find_availability(request)
        no_appts_avail? ? nil : select_available_appt(request)
    end

    private

    def select_available_appt(request)
        avail_appt = appointments.select { |appt| appt['time'] >= request } # changed this from == and therefore removed next_avail_appt method
        !avail_appt.empty? ? book_appointment(avail_appt) : nil # next_avail_appt(request)
    end

    def book_appointment(avail_appt)
        appointments.delete(avail_appt[0])
        update_appointments_file
        avail_appt[0]['time']
    end

    def update_appointments_file
        appointment_hash.slots['availability_slots'] = appointments
        File.open(json_file, 'w') { |json_file| json_file.write(appointment_hash.slots.to_json) }
    end
    # def next_avail_appt(request)
    #     if Time.parse(request) > Time.parse(CLINIC_CLOSED)
    #         nil
    #     else
    #         request = (Time.parse(request) + ADD_TEN_MINS).strftime(TIME_FORMAT)
    #         find_availability(request)
    #     end
    # end

    def no_appts_avail?
        appointments.empty?
    end
end

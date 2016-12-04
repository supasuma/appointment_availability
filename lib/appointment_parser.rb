require 'json'

class Appointment_parser
    attr_reader :slots, :json

    def initialize(json)
        @json = json
        file = File.read(json)
        @slots = JSON.parse(file)
    end
end

require 'json'
require_relative 'availability'

class AppointmentParser
    attr_reader :slots

    def initialize(json)
        file = File.read(json)
        @slots = JSON.parse(file)
    end

    def update_json(json_file, updated_hash)
        File.write(json_file, JSON.pretty_generate(updated_hash))
    end
end

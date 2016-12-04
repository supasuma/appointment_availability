#!/usr/bin/env ruby

# This morning I realised that this file should be something like it is below rather
# than the pure script file it was.  So unfortunately I didn't have time to create
# tests for this last minute class - if you would like to see the original script file
# do let me know.

require './lib/availability.rb'
require 'json'
require 'time'

class Interface
    attr_reader :time, :availability, :json_file # :appointments, :data,

    TIME_FORMAT = '%H:%M:%S'.freeze
    TIME_FORMAT_CHECK = /^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-9][0-9]$/

    def initialize(time, file = './availability_slots.json')
        @time = time || nil
        @json_file = file
        # file = File.read(JSON_FILE)
        # @data = JSON.parse(file)
        # @appointments = data['availability_slots']
        @availability = Availability.new(json_file)
    end

    def prompt_user_input
        if time.nil?
            $stdout.puts 'What time would you like to book?'
            user_time = $stdin.gets
        else
            user_time = time
        end
        check_time_valid(user_time)
    end

    def check_time_valid(user_time)
        until TIME_FORMAT_CHECK.match(user_time)
            $stdout.puts "Invalid time format! Make sure you use ':' e.g. '8:00'"
            $stdout.puts 'Please enter a valid time'
            user_time = $stdin.gets
        end
        slot_time = Time.parse(user_time).strftime(TIME_FORMAT)
        find_availability(slot_time)
    end

    def find_availability(slot_time)
        appointment_time = availability.find_availability(slot_time)
        if appointment_time.nil?
            $stdout.puts 'There are no appointments available after 3pm, or we may be fully booked'
        else
            $stdout.puts 'Your appointment is at ' + appointment_time
            # confirm_booking
        end
    end

    # def confirm_booking
    #     $stdout.puts 'Please confirm you would like this booking? please enter Y or N'
    #     user_answer = $stdin.gets.chomp
    #     if user_answer.casecmp('Y').zero?
    #         availability.update_appointments_file
    #         # data['availability_slots'] = appointments
    #         # File.open(JSON_FILE, 'w') { |json_file| json_file.write(data.to_json) }
    #     end
    # end
end

Interface.new(ARGV.first || nil).prompt_user_input

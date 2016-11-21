#!/usr/bin/env ruby

# This morning I realised that this file should be something like it is below rather
# than the pure script file it was.  So unfortunately I didn't have time to create
# tests for this last minute class - if you would like to see the original script file
# do let me know.

require_relative "availability.rb"
require "json"
require "time"

class Interface

attr_reader :time, :appointments, :data, :availability

TIME_FORMAT = "%H:%M:%S"
TIME_FORMAT_CHECK = /^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0]$/
JSON_FILE = "./availability_slots.json"

  def initialize(time)
    @time = time || nil
    file = File.read(JSON_FILE)
    @data = JSON.parse(file)
    @appointments  = data["availability_slots"]
    @availability = Availability.new(appointments)
  end

  def prompt_user_input
    if time == nil
      $stdout.puts "What time would you like to book?"
      user_time = $stdin.gets
    else
      user_time = time
    end
    check_time_valid(user_time)
  end

  def check_time_valid(user_time)
    while !TIME_FORMAT_CHECK.match(user_time)
      $stdout.puts "Invalid time format! Make sure you use ':' & select a time that is on the hour or at 10 minute intervals after."
      $stdout.puts "Please enter a valid time"
      user_time = $stdin.gets
    end
    request = Time.parse(user_time).strftime(TIME_FORMAT)
    find_availability(request)
  end

  def find_availability(request)
    availability_result = availability.find_availability(request)
    if availability_result.nil?
      $stdout.puts "There are no appointments available after 3pm, or we may be fully booked"
    else
      $stdout.puts "Your appointment is at " + availability_result
      confirm_booking
    end
  end

  def confirm_booking
    $stdout.puts "Please confirm you would like this booking? please enter Y or N"
    user_answer = $stdin.gets.chomp
    if user_answer.upcase == "Y"
      data["availability_slots"] = appointments
      File.open(JSON_FILE, "w") { |json_file| json_file.write(data.to_json) }
    end
  end

end

Interface.new(ARGV.first || nil).prompt_user_input

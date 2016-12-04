require 'interface'

describe Interface do
    subject(:interface) { described_class.new(time, 'spec/json_test_file_2.json') }

    after(:each) do
        IO.copy_stream('spec/json_test_file_1.json', 'spec/json_test_file_2.json')
    end

    context 'no time entered' do
        let(:time) { nil }

        it 'prompts user for a time if none entered and books' do
            allow(STDIN).to receive(:gets).and_return('8:00')
            prompt = 'What time would you like to book?' + "\n"
            booking = 'Your appointment is at 08:00:00' + "\n"
            expect { interface.prompt_user_input }.to output(prompt + booking).to_stdout
        end
    end

    context 'invalid time' do
        let(:time) { '8.00' }

        it 'if time invalid asks for valid time & books appointment' do
            allow(STDIN).to receive(:gets).and_return('8:00')
            message = "Invalid time format! Make sure you use ':' e.g. '8:00'" + "\n"
            message2 = 'Please enter a valid time' + "\n"
            booking = 'Your appointment is at 08:00:00' + "\n"
            expect { interface.check_time_valid(time) }.to output(message + message2 + booking).to_stdout
        end
    end

    context 'after hours or fully booked' do
        let(:time) { '16:00' }

        it 'if after hours or fully booked will return descriptive message' do
            message = 'There are no appointments available after 3pm, or we may be fully booked' + "\n"
            expect { interface.find_availability(time) }.to output(message).to_stdout
        end
    end
end

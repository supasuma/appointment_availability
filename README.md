# babylon_tech_test

This command line application allows patients to request doctors appointments.  The core functionality has been created using pure Ruby and is tested using RSpec.  

I added some additional functionality over and above what was explicitly stated in the test instructions to make it a more user friendly experience.  I also provided the ability to update the json file which I felt was an implied requirement.

### To use this application

```
Clone this repo
```
```
$ bundle
```
```
navigate to the root directory (unfortunately this is 2 folders deep)
```
Enter the below into the command line either with an appointment time as shown, or without and the app will prompt you to enter a time.

```
$ ./interface.rb 8:40
```

### User Stories
```

User stories

As a patient
So that I can book an Appointment
I would like to be able to request a time.

As a patient
So that I know what time my appointment is
I would like to see my time printed as confirmation.
```
### Instructions provided for this tech test

Your task is to create an app that will allow patients to book appointments with a doctor, using the dataset provided.

**Requirements**
You should create a command line app that accepts a single argument, which is the time that the patient would like to book to see a doctor. Eg:

$ ./availability.rb 12:40
The app should check which is the next available slot and book it. It should print the time of the appointment that was booked

**Additional Requirements**
Patients cannot book appointments before 8am and after 3pm. Once an availability has been used up for an appointment it cannot be booked again.

In the dataset there are multiple doctors (id: 1 & 2) and each doctor can only have 1 appointment per slot. For example, you could potentially book 12:20 once for doctor 1 and again for doctor 2.

**Constraints**
Please use the JSON file provided to load availability into your app.
Your app should be an executable ruby script (command line).
Your app should accept a time (eg: 12:40)
Your app should print the time that was booked (eg: 1:10)

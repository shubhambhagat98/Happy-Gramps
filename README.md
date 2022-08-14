
## Happy Grampp - A Senior Citizens Safety Appilcation

<img src="https://user-images.githubusercontent.com/53030762/182968720-97b146ff-2943-4f64-b133-19d3d11f4fa3.png" align="right" height="280" />
  
- In this project, we have tried to leverage smartphone technology to develop a no-cost solution for providing a safety mechanism to senior citizens.

- Happy Gramps is a cross-platform mobile application that offers safety features to senior citizens in case of an emergency.    
  
- To aid senior citizens in their daily lives, Happy Gramps offers various functionalities such as fall detection system with emergency alert, user location tracking, emergency contact list and utilities such as medicine reminder, to-do task reminder and priority-based information notebook.  
  
- Working video demo of this application can be viewed using this link.


## Tech Stack
- Programming Language: Dart, Kotlin
- Framework: Flutter
- IDE and Libraries: Android Studio SDK, Android Emulator, VsCode
- Database: SQLite
- UI Design: Figma

## Component Overview

**1) Home page**

- The UI was kept clean and simple for easy navigation for use by senior citizens.  
- Different colours were used for better differentiation between functionalities.    
- The homepage layout was designed to be self-explanatory.    
- Just by looking at the screen the user will understand the purpose of the different buttons provided.

<div align="center">
  <img src="https://user-images.githubusercontent.com/53030762/182973060-de0277bf-a506-49c2-9f56-701272e064f6.png" align="center" height="450" />
</div>


<br />

**2) Fall Detection**

- In a fall situation, there is a large change in acceleration within a split second and then after the fall, the person lies still for some time, showing no change in orientation.  
- For fall detection, the smartphone’s inbuilt gyroscope and accelerometer sensor will be used.  A gyroscope is used to determine an orientation and an accelerometer provides the information about the angular parameter as three-axis data (acceleration magnitude).
- The input values captured by gyroscope and accelerometer will be compared with a predefined threshold. If the input value of acceleration magnitude crosses the threshold within some specified time interval, and after that if there is no change in orientation for a specific time interval, then a fall is detected.    
- These fall events are informed to the pre-specified caretaker by alert messages.   
- The fall detection service is always active in background even if the app is minimized or removed from recent apps. 

<div align="center">
  <img src="https://user-images.githubusercontent.com/53030762/182971920-4d6affc9-5dcc-4250-a367-9a5aec9d1d89.png" align="center" height="450" />
  <img src="https://user-images.githubusercontent.com/53030762/182971972-9b7be0f7-a612-41db-acb4-c829b37a1aa3.png" align="center" height="450" />
</div>

<br />

**3) SOS/Panic Button**

- When the SOS button is pressed, an emergency alert is sent to the emergency contact in the form of an SMS. 
- If the internet is available then the SMS is sent with the location of the user otherwise a simple SMS alert message is sent. 
- A loud horn-like sound is played to alert nearby people who might be able to help the user.

<div align="center">
  <img src="https://user-images.githubusercontent.com/53030762/182974768-f7592980-bb00-469d-bf57-3755d86fe196.png" height="450" />
</div>

<br />

**4) Medicine Reminder**

- This Section is used to store information about daily medicines.  
- User can add medicine information such as medicine name, dosage, type, interval and start time.  
- A reminder notification is displayed along with vibration pattern and notification tune to alert/reminder the user to take the medicine.

<div align="center">
  <img src="https://user-images.githubusercontent.com/53030762/182975266-be56fbb2-5ff2-47ce-ac96-8207d740d90b.png" height="450" />
</div>

<br />

**5) Todo Reminder**

- This Section is used to store information about certain task to be done.  
- User can add task information such as task name, task date and time.
- A reminder notification is displayed along with vibration pattern and notification tune to alert/remind the user about the task.

<div align="center">
  <img src="https://user-images.githubusercontent.com/53030762/183233813-6bc0ed0e-1c2c-45cb-98e5-be047ea047be.png" height="450" />
</div>

<br />

**6) Emergency Contact List**

- Here, user must save certain contacts to be contacted in case of emergency.
- User can enter information such as contact name, number, email-id, category.
- Contacts which have category as Family or SOS are alerted in case of any emergency.

<div align="center">
  <img src="https://user-images.githubusercontent.com/53030762/183233999-ac88f644-bbc5-44c5-9499-a34ec922d70e.png" height="450" />
</div>

<br />


**7) Information Notebook**

- Here, user can store some information which may difficult to remember but can be needed at crucial time.
- Each piece of information is stored as a note with different priority - High, Medium, Low.
- Different colors are used to differentiate the priority of the notes as- Red, yellow, green.


<div align="center">
  <img src="https://user-images.githubusercontent.com/53030762/183234119-039b2325-8589-4be0-a93d-8314b3d201c8.png" align="center" height="450" />
  <img src="https://user-images.githubusercontent.com/53030762/183234123-ab703075-2411-4b0e-a766-06afa6025180.png" align="center" height="450" />
</div>

## How to run the project

- Clone this repo
- Follow [Get Started](https://flutter.dev/docs/get-started/install) tutorial and install Flutter
- Start Android emulator
- Run the app from terminal with `flutter run`


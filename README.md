## Disclaimer: This application is built as my academic project; it is not suitable to deploy this in a real-world environment.
<p align="center">
  <img src="assets/images/pawpal.png" alt="PawPal Logo" width="512">
</p>

# PawPal

PawPal is an application for users who seek to adopt and donate to pets in need. It allows users to upload their own pets for other users to help by adopting them or donate foods to medical supplies to them.


## Features

- User account authentications wwith password encryption (SHA1)
- Pets browsing with search and filter
- Pet donation and adoption function
- Online Payment for donation


## Installation

For setting up this system locally you will need:
- XAMPP Control Panel v3.3.0
- Code Editor, preferably VS Code with Flutter SDK installed
- Git

1. Create a folder and clone this repository into it
```bash
  git clone https://github.com/KaizerIsTheFrog/pawpal.git
  cd pawpal
```
2. Open VSCode and open the folder above

3. Install dependencies with the command below
```bash
  flutter pub get
```

4. Open XAMPP Control Panel and click Explorer on the left
5. Click into folder named 'htdocs', create a folder called 'pawpal'
6. Copy the 'api' folder in your repository and put into the 'pawpal' folder in Step 5
7. Start the Apache module and MySQL module in XAMPP
8. Visit http://localhost/phpmyadmin/ after Apache and MySQL started running
9. Click new database on the left section, and look for import section on the top
10. Click Browse file and select pawpal_db.sql located in php/api folder
11. open cmd and run, locate the ipv4 address using
```bash
  ipconfig
```
13. Edit the my_config.dart file and replace the baseUrl with
```bash
  static const String baseUrl = "http://[your address here]";
```
15. After that, save and run the project with command below
```bash
  flutter run
```

<b>For those who want to use normally, skip step 4 to 15</b>

## API Usages
<b>DB Connect</b>
* `dbconnect.php` - api to get connection from the database

<b>Fetch Requests</b>
* `login_user.php` - a user authentication api to fetch and check if user is in database or not
* `get_other_pets.php` - get all pets from other users
* `get_my_donations.php` - get all donations that made by user
* `get_my_pets.php` - get all pets that submitted by user

<b>Post Requests</b>
* `register_user.php` - user authentication api to create new record if user is not in database
* `update_user_data.php` - update user information to database
* `submit_pet.php` - create new record of pets
* `submit_adoption_request.php` - create new record of adoption of a specific pet
* `submit_donation.php` - create neww record of donation to a specific pet





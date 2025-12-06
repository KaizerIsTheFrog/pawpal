# pawpal

Flutter project for lab assignment.
o	setup steps

under the php file, the .php files should be put under ..\Xampp\htdocs\pawpal\api folder

while the .sql file should be imported into phpmyadmin

o	API explanation
api are the .php files under pfp folder, explanation as follow:

dbconnect.php is used across the .php files for conn to the database

get_my_pets.php is used to fetch all pets the current userr submitted

login_user.php is used to comm to the db and login into the app

register_user.php is used to comm to the db and add new user to database

submit_pet is used to submit a pet to later show in the mainpage

o	sample JSON

{"status":"failed","message":"At least 1 image is required."}

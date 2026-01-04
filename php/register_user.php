<?php
// connection variables
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pawpal_db";
// $port = 3307;

// $conn = new mysqli($servername, $username, $password, $dbname, $port);
$conn = new mysqli($servername, $username, $password, $dbname);

// connection
if ($conn->connect_error){
    die(json_encode(array("success"=>false, "message"=>"Database connection failed")));
}

// Accepts POST data: name, email, password, phone
$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['password'];
$phone = $_POST['phone'];

// check empty
if (empty($name) || empty($email) || empty($phone) || empty($password)) {
    echo json_encode(array("success"=>false, "message"=>"All fields need to be filled"));
    return;
}

// Checks for duplicate email
$checkEmail = "SELECT * FROM tbl_users WHERE email = '$email'";
$result = $conn->query($checkEmail);

if ($result->num_rows > 0) {
    echo json_encode(array("success"=>false, "message"=>"Email already exists"));
    return;
}

// Hashes password using password_hash() or sha1() [using sha1]
$hashedPassword = sha1($password);

// Inserts data into tbl_users
$sql = "INSERT INTO tbl_users(name, email, password, phone) 
        VALUES ('$name', '$email', '$hashedPassword', '$phone')";

// Returns JSON response with success/error message
if ($conn->query($sql) === TRUE) {
    echo json_encode(array("success"=>true, "message"=>"Registration successful"));
} else {
    echo json_encode(array("success"=>false, "message"=>"Registration failed"));
}

$conn->close();
?>
<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pawpal_db";
$port = 3307;

// create conn
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Check connection
if ($conn->connect_error) {
    // die() sends plain text output and terminates, which is usually fine for a failed connection
    die("Connection failed: " . $conn->connect_error);
}

// Accepts POST data: email, password
$email = $_POST['email'];
$password = $_POST['password'];

// validate user login
if (empty($email) || empty($password)) {
    echo json_encode(array("success"=>false, "message"=>"All fields need to be filled"));
    return;
}

// hash password like register
$hashedPassword = sha1($password);

// check if user exists
$sql = "SELECT * FROM tbl_users WHERE email = '$email' AND password = '$hashedPassword'";
$result = $conn->query($sql);

// Returns JSON with user details on success or an error message
if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();

    echo json_encode(array(
        "success" => true,
        "message" => "Login successful",
        "data" => [
            array(
                "user_id" => $user["user_id"],
                "name" => $user["name"],
                "email" => $user["email"],
                "phone" => $user["phone"]
            )
        ]
    ));
} 
else {
    echo json_encode(array("success"=>false, "message"=>"Invalid email or password"));
}

$conn->close();
?>
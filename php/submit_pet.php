<?php
header("Access-Control-Allow-Origin: *");

// connection variables
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pawpal_db";
$port = 3307;

$conn = new mysqli($servername, $username, $password, $dbname, $port);

// conn
if ($conn->connect_error){
    sendJsonResponse(array("status"=>"failed", "message"=>"Database connection failed"));
}


if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    sendJsonResponse(array('status' => 'failed', 'message' => 'Method Not Allowed'));
}

// retrieve post
$userid = $_POST['user_id'] ?? '';
$petname = addslashes($_POST['pet_name'] ?? '');
$pettype = $_POST['pet_type'] ?? '';
$category = $_POST['category'] ?? '';
$description = addslashes($_POST['description'] ?? '');
$lat = $_POST['lat'] ?? '';
$lng = $_POST['lng'] ?? '';


// check empty
if (empty($userid) || empty($petname)) {
    sendJsonResponse(['status' => 'failed', 'message' => 'Missing required User ID or Pet Name.']);
}

$sqlinsertpet = "
    INSERT INTO `tbl_pets`
    (`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `image_paths`) 
    VALUES 
    ('$userid','$petname','$pettype','$category','$description','$lat','$lng','')
";

?>
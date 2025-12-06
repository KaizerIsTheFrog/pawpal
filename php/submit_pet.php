<?php
header("Access-Control-Allow-Origin: *");

include 'dbconnect.php';


if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    sendJsonResponse(array('status' => 'failed', 'message' => 'Method Not Allowed'));
    exit();
}

// retrieve post
$userid = $_POST['user_id'] ?? '';
$petname = addslashes($_POST['pet_name'] ?? '');
$pettype = $_POST['pet_type'] ?? '';
$category = $_POST['category'] ?? '';
$description = addslashes($_POST['description'] ?? '');
$lat = $_POST['lat'] ?? ''; 
$lng = $_POST['lng'] ?? ''; 
$encodedimage = base64_decode($_POST['image']);


// check empty
if (empty($userid) || empty($petname)) {
    sendJsonResponse(['status' => 'failed', 'message' => 'Missing required User ID or Pet Name.']);
}

$sqlinsertpet = "
    INSERT INTO `tbl_pets`
    (`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `image_paths`) 
    VALUES 
    ('$userid','$petname','$pettype','$category','$description','$lat','$lng','$encodedimage')
";

try {
    if ($conn->query($sqlinsertpet) === TRUE) {
        $current_pet_id = $conn->insert_id;
        $path = "../assets/pets/pet_".$last_id.".png";
        file_put_contents($path, $encodedimage); 
        
        $response = array('status' => 'success', 'message' => 'Service added successfully');
        sendJsonResponse($response);

    } else {
        $response = array('status' => 'failed', 'message' => 'Pet submission failed');
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => $e->getMessage());
    sendJsonResponse($response);
}
?>
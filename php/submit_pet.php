<?php
header("Access-Control-Allow-Origin: *");

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
    exit(); 
}

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pawpal_db";
$port = 3307;

$conn = new mysqli($servername, $username, $password, $dbname, $port);

if ($conn->connect_error){
    sendJsonResponse(array("status"=>"failed", "message"=>"Database connection failed"));
}

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
$base64_data = $_POST['image1'] ?? '';


// check empty
if (empty($userid) || empty($petname)) {
    sendJsonResponse(['status' => 'failed', 'message' => 'Missing required User ID or Pet Name.']);
}

$sqlinsertpet = "INSERT INTO `tbl_pets`
(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `image_paths`, `created_at`) 
VALUES 
('$userid','$petname','$pettype','$category','$description','$lat','$lng','','$now')
";

try {
    if ($conn->query($sqlinsertpet) === TRUE) {
        $current_pet_id = $conn->insert_id;
        $target_dir = "../assets/pets/"; // File system path

        $filename = "pet_" . $current_pet_id . ".png";
        $filepath = $target_dir . $filename; 
        
        $db_path = "/pawpal/assets/pets/" . $filename; 

        if (file_put_contents($filepath, $encodedimage) !== FALSE) {
            
            $sqlupdatepath = "UPDATE `tbl_pets` SET `image_paths` = '$db_path' WHERE `pet_id` = '$current_pet_id'";
            
            if ($conn->query($sqlupdatepath) === TRUE){
                 sendJsonResponse(array('status' => 'success', 'message' => 'Pet submitted successfully'));
            } else {
                $conn->query("DELETE FROM `tbl_pets` WHERE `pet_id` = '$current_pet_id'");
                if (file_exists($filepath)) { unlink($filepath); }
                sendJsonResponse(array('status' => 'failed', 'message' => 'Pet data inserted, but failed to update image path.'));
            }
            
        } else {
            $conn->query("DELETE FROM `tbl_pets` WHERE `pet_id` = '$current_pet_id'");
            sendJsonResponse(array('status' => 'failed', 'message' => 'Image saving failed. Check folder permissions.'));
        }

    } else {
        $response = array('status' => 'failed', 'message' => 'Pet submission failed');
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => $e->getMessage());
    sendJsonResponse($response);
}
?>
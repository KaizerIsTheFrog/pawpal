<?php
    header("Access-Control-Allow-Origin: *");
    include 'dbconnect.php';
    
    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        http_response_code(405);
        $response = array('success' => false, 'message' => 'Method Not Allowed');
        sendJsonResponse($response);
        exit();
    }
    
    // Check required fields
    if (!isset($_POST['user_id']) || !isset($_POST['name']) || !isset($_POST['phone'])) {
        http_response_code(400);
        $response = array('success' => false, 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }
    
    $userId = $_POST['user_id'];
    $name = addslashes($_POST['name']);
    $phone = $_POST['phone'];
    
    // Check if image is provided
    $hasImage = isset($_POST['image']) && !empty($_POST['image']);
    
    try {
        if ($hasImage) {
            // Decode base64 image
            $base64Image = base64_decode($_POST['image']);
            $filename = "../assets/profile/profile_" . $userId . "_" . time() . ".png";
            
            // Save image
            file_put_contents($filename, $base64Image);
            $imagePath = $filename;
            
            // Update profile with image
            $sqlupdateprofile = "UPDATE `tbl_users` SET `name` = '$name', `phone` = '$phone', `profile_image_path` = '$imagePath' WHERE `user_id` = '$userId'";
        } else {
            // Update profile without image
            $sqlupdateprofile = "UPDATE `tbl_users` SET `name` = '$name', `phone` = '$phone' WHERE `user_id` = '$userId'";
        }
        
        if ($conn->query($sqlupdateprofile) === TRUE) {
            $response = array('success' => true, 'message' => 'Profile updated successfully');
            sendJsonResponse($response);
        } else {
            $response = array('success' => false, 'message' => 'Profile update failed');
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        $response = array('success' => false, 'message' => $e->getMessage());
        sendJsonResponse($response);
    }
    
    // Function to send json response  
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>
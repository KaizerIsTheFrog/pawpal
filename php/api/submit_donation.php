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
if (!isset($_POST['pet_id']) || !isset($_POST['user_id']) || !isset($_POST['donation_type'])) {
    http_response_code(400);
    $response = array('success' => false, 'message' => 'Bad Request: Missing required fields');
    sendJsonResponse($response);
    exit();
}

$petId = intval($_POST['pet_id']);
$userId = intval($_POST['user_id']);
$donationType = $conn->real_escape_string($_POST['donation_type']);

// Validate donation type
if (!in_array($donationType, ['Money', 'Food', 'Medical'])) {
    http_response_code(400);
    $response = array('success' => false, 'message' => 'Invalid donation type');
    sendJsonResponse($response);
    exit();
}

// Handle amount or description based on donation type
if ($donationType == 'Money') {
    // Money donation
    // Check required fields
    if (!isset($_POST['amount']) || empty($_POST['amount'])) {
        http_response_code(400);
        $response = array('success' => false, 'message' => 'Amount is required for money donation');
        sendJsonResponse($response);
        exit();
    }
    $amount = floatval($_POST['amount']);
    $description = '';
} else {
    // Food or Medical donation
    // Check required fields
    if (!isset($_POST['description']) || empty($_POST['description'])) {
        http_response_code(400);
        $response = array('success' => false, 'message' => 'Description is required for ' . $donationType . ' donation');
        sendJsonResponse($response);
        exit();
    }
    $amount = 0;
    $description = $conn->real_escape_string($_POST['description']);
}

// Insert donation into database
$sqlInsert = "INSERT INTO `tbl_donations` (`pet_id`, `donator_user_id`, `donation_type`, `amount`, `description`) 
              VALUES ($petId, $userId, '$donationType', $amount, '$description')";

try {
    if ($conn->query($sqlInsert) === TRUE) {
        $response = array(
            'success' => true, 
            'message' => 'Donation has been submitted successfully'
        );
        sendJsonResponse($response);
    } else {
        http_response_code(500);
        $response = array(
            'success' => false, 
            'message' => 'Failed to submit donation: ' . $conn->error
        );
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    http_response_code(500);
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
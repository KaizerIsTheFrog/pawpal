<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'GET') {
    http_response_code(405);
    $response = array('success' => false, 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}

// Check required fields
if (!isset($_GET['user_id']) || empty($_GET['user_id'])) {
    http_response_code(400);
    $response = array('success' => false, 'message' => 'Bad Request: user_id is required');
    sendJsonResponse($response);
    exit();
}

$userId = intval($_GET['user_id']);

// Query to get user's donations with pet information
// FIXED: Changed user_id to donator_user_id and donation_date to donated_at
$sqlQuery = "
    SELECT 
        d.donation_id,
        d.pet_id,
        d.donator_user_id AS user_id,
        d.donation_type,
        d.amount,
        d.description,
        d.donated_at AS donation_date,
        p.pet_name,
        p.pet_type
    FROM tbl_donations d
    JOIN tbl_pets p ON d.pet_id = p.pet_id
    WHERE d.donator_user_id = $userId
    ORDER BY d.donated_at DESC
";

try {
    $result = $conn->query($sqlQuery);

    if ($result && $result->num_rows > 0) {
        $donations = array();
        while ($row = $result->fetch_assoc()) {
            $donations[] = $row;
        }
        $response = array('success' => true, 'data' => $donations);
        sendJsonResponse($response);
    } else {
        $response = array('success' => false, 'data' => null, 'message' => 'No donations found');
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
<?php
// Set headers and error reporting
header("Access-Control-Allow-Origin: *");

// --- Database Connection Details ---
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pawpal_db";
$port = 3307;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Check connection
if ($conn->connect_error) {
    // die() sends plain text output and terminates
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    // ⚠️ FIX: Initialize searchCondition to prevent "Undefined variable" Notice and FormatException
    $searchCondition = ""; 

    // 1. Retrieve the user ID from the POST request
    if (isset($_POST['user_id']) && !empty($_POST['user_id'])) {
        $user_id = $conn->real_escape_string($_POST['user_id']);
    } elseif (isset($_POST['user']) && !empty($_POST['user'])) {
        // Fallback for older/incorrectly named parameter
        $user_id = $conn->real_escape_string($_POST['user']); 
    } else {
        $user_id = '';
    }

    if (empty($user_id)) {
        sendJsonResponse(['status' => 'failed', 'message' => 'User ID is missing or invalid.']);
        exit();
    }
    
    // 2. Pagination Setup
    $results_per_page = 10;
    $curpage = isset($_POST['curpage']) ? (int)$_POST['curpage'] : 1;
    $page_first_result = ($curpage - 1) * $results_per_page;

    // 3. Build Base Query with User Filter
    $baseQuery = "
        SELECT 
            p.pet_id,
            p.user_id,
            p.pet_name,
            p.pet_type,
            p.category,
            p.description,
            p.image_paths,
            p.lat,
            p.lng,
            p.created_at
        FROM tbl_pets p
        WHERE p.user_id = '$user_id'
    ";
    
    // 4. Search Logic (You can uncomment and use this if Flutter sends a 'search' parameter)
    /*
    if (isset($_POST['search']) && !empty($_POST['search'])) {
        $search = $conn->real_escape_string($_POST['search']);
        $searchCondition = " AND (
            p.pet_name LIKE '%$search%' 
            OR p.pet_type LIKE '%$search%'
            OR p.category LIKE '%$search%'
        )";
    }
    */

    // 5. Execute query without LIMIT first to get total count
    $sqlloadpets = $baseQuery . $searchCondition . " ORDER BY p.pet_id DESC";

    $result = $conn->query($sqlloadpets);
    $number_of_result = 0;
    if ($result) {
        $number_of_result = $result->num_rows;
    }
    $number_of_page = ceil($number_of_result / $results_per_page);

    // 6. Add LIMIT and fetch final data
    $sqlloadpets .= " LIMIT $page_first_result, $results_per_page";
    $result = $conn->query($sqlloadpets);

    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        $response = array(
            'status' => 'success', 
            'pets' => $petdata,
            'numofpage' => $number_of_page, 
            'numberofresult' => $number_of_result
        );
        sendJsonResponse($response);
    } else {
        $response = array(
            'status' => 'failed', 
            'pets' => [], 
            'numofpage' => $number_of_page, 
            'numberofresult' => $number_of_result,
            'message' => 'No pets found for this user.'
        );
        sendJsonResponse($response);
    }

} else {
    sendJsonResponse(['status' => 'failed', 'message' => 'Invalid Request Type']);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
    exit(); 
}
?>
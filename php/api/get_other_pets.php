<?php
header("Access-Control-Allow-Origin: *");

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';

    $currentUserId = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;
    
    // Base JOIN query
    $baseQuery = "
        SELECT 
            s.pet_id,
            s.user_id,
            s.pet_name,
            s.pet_type,
            s.gender,
            s.age,
            s.health_status,
            s.category,
            s.description,
            s.image_paths,
            s.lat,
            s.lng,
            s.created_at,
            u.name,
            u.email,
            u.phone
        FROM tbl_pets s
        JOIN tbl_users u ON s.user_id = u.user_id
        WHERE s.user_id != $currentUserId
    ";

    // condition string for search and filter
    $sqlcondition = "";

    // Search logic
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sqlcondition .= "
            AND (s.pet_name LIKE '%$search%' 
            OR s.pet_type LIKE '%$search%'
            OR s.category LIKE '%$search%')";
    }

    if (isset($_GET['filter']) && !empty($_GET['filter'])) {
        $filterType = $conn->real_escape_string($_GET['filter']);
        $sqlcondition .= " AND s.pet_type = '$filterType'";
    }

    $sqlloadpet = $baseQuery . $sqlcondition . " ORDER BY s.pet_id DESC";

    // Execute query
    $result = $conn->query($sqlloadpet);

    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        $response = array('success' => true, 'data' => $petdata);
        sendJsonResponse($response);
    } else {
        $response = array('success' => false, 'data' => null, 'message' => 'No Data Found');
        sendJsonResponse($response);
    }

} else {
    $response = array('success' => false, 'message' => 'Invalid request method');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		$response = array('success' => false, 'message' => 'Method Not Allowed');
	    sendJsonResponse($response);
		exit();
	}

    if (!isset($_POST['pet_id']) || !isset($_POST['requester_user_id']) || !isset($_POST['message']) || !isset($_POST['status'])) {
			http_response_code(400);
			$response = array('success' => false, 'message' => 'Bad Request: Missing required fields');
			exit();
		}

    $petId = $_POST['pet_id'];
	$userid = $_POST['requester_user_id'];
	$message = addslashes($_POST['message']);
	$status = $_POST['status'];

	// Insert new pet into database
	$sqlinsertadoptionrequest = "INSERT INTO `tbl_adoptions`(`pet_id`, `requester_user_id`, `message`, `status`) 
	VALUES ('$petId','$userid','$message','$status')";
    try {
        if ($conn->query($sqlinsertadoptionrequest) === TRUE) {
            $response = array('success' => true, 'message' => 'Adoption request submitted successfully');
            sendJsonResponse($response);
        } else {
            http_response_code(500);
            $response = array('success' => false, 'message' => 'Failed to submit adoption request');
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
		http_response_code(500);
        $response = array('success' => false, 'message' => $e->getMessage());
        sendJsonResponse($response);
    }
    

//	function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
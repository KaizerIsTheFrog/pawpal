<?php
	header("Access-Control-Allow-Origin: *"); // allow any site to send credential to my server

	if ($_SERVER['REQUEST_METHOD'] == 'POST') {

		if (!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['phone'])) {

			http_response_code(400);
			$response = array('success' => false, 'message' => 'Bad Request');
			exit();

		}

		include 'dbconnect.php';
		$name = $_POST['name'];
		$email = $_POST['email'];
		$password = $_POST['password'];
		$hashedpassword = sha1($password);
		$phone = $_POST['phone'];

		// Check duplicate email
		$sqlcheckemail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
		$result = $conn->query($sqlcheckemail);

		if ($result->num_rows > 0){
			$response = array('success' => false, 'message' => 'Email already registered');
			sendJsonResponse($response);

			exit();
		}

		// Insert new user into database
		$sqlregister = "INSERT INTO `tbl_users`(`name`, `email`, `password`, `phone`) VALUES ('$name','$email','$hashedpassword', '$phone')";
		try {
			if ($conn->query($sqlregister) === TRUE){
				$response = array('success' => true, 'message' => 'Registration Successful');
				sendJsonResponse($response);

			} else {
				$response = array('success' => false, 'message' => 'Registration Failed');
				sendJsonResponse($response);

			}
		} catch (Exception $e) {
			$response = array('success' => false, 'message' => $e->getMessage());
			sendJsonResponse($response);

		}

	} else {
		http_response_code(405);
		$response = array('success' => false, 'message' => 'Method Not Allowed');

		exit();
	}


    //	function to send json response	
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>
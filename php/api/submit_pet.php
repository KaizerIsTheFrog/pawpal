<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		$response = array('success' => false, 'message' => 'Method Not Allowed');
	    sendJsonResponse($response);
		exit();
	}

    if (!isset($_POST['user_id']) || !isset($_POST['pet_name']) || !isset($_POST['pet_type']) || !isset($_POST['category']) || !isset($_POST['description']) || !isset($_POST['lat']) || !isset($_POST['lng']) || !isset($_POST['image'])) {
			http_response_code(400);
			$response = array('success' => false, 'message' => 'Bad Request');
			exit();
		}

	$userid = $_POST['user_id'];
	$petName = $_POST['pet_name'];
	$petType = $_POST['pet_type'];
	$category = $_POST['category'];
	$description = addslashes($_POST['description']);
	$lat = $_POST['lat'];
	$lng = $_POST['lng'];
	$imageList = json_decode($_POST['image'], true);

	// Insert new pet into database
	$sqlinsertpet = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`,`image_paths`,`lat`, `lng`) 
	VALUES ('$userid','$petName','$petType','$category','$description','','$lat','$lng')";
	try{
		if ($conn->query($sqlinsertpet) === TRUE){
            $countImage = count($imageList);
            $last_id = $conn->insert_id; //Get Auto Increment Id
            $imagePath = [];
            for($x = 0; $x < $countImage; $x++){
                $base64Image = base64_decode($imageList[$x]);
			    $filename = "../assets/pets/pet_".$last_id."_".($x + 1).".png";
                file_put_contents($filename, $base64Image);
                $imagePath[] = $filename; //Store image path if there are multiple upload
            }

            $imageJsonPath = json_encode($imagePath);
            $updateImagePath = "UPDATE `tbl_pets` SET `image_paths` = '$imageJsonPath' WHERE `pet_id` ='$last_id'";
            if($conn->query($updateImagePath) === TRUE){
                $response = array('success' => true, 'message' => 'Pet submitted successfully');
                sendJsonResponse($response);
            }else{
                $response = array('success' => false, 'message' => 'Pet submitted failed');
                sendJsonResponse($response);
            }
		}
	}catch(Exception $e){
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
<?php
    header("Access-Control-Allow-Origin: *"); // allow any site to send credential to my server

    //Check type POST request and check the post data is email and password or not
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {

        if (!isset($_POST['email']) || !isset($_POST['password'])) {

            $response = array('success' => false, 'message' => 'Bad Request');
            sendJsonResponse($response);
            exit();

        }

        include 'dbconnect.php';
        
        $email = $_POST['email'];
        $password = $_POST['password'];
        $hashedpassword = sha1($password);

        $sqllogin = "SELECT * FROM `tbl_users` WHERE `email` = '$email' AND `password` = '$hashedpassword'";

        $result = $conn->query($sqllogin);

        if ($result->num_rows > 0) {
            $userdata = array();

            while ($row = $result->fetch_assoc()) {
                $userdata[] = $row;
            }

            $response = array('success' => true, 'message' => 'Login successful', 'data' => $userdata);
            sendJsonResponse($response);
            
        } else {

            $response = array('success' => false, 'message' => 'Invalid email or password','data'=>null);
            sendJsonResponse($response);

        }

    } else {

        $response = array('success' => false, 'message' => 'Method Not Allowed');
        sendJsonResponse($response);
        exit();

    }

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
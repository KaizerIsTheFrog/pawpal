<?php
error_reporting(0);
//include_once("dbconnect.php");

$email = $_GET['email']; 
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount'];
$userid = $_GET['userid'];
$petid = $_GET['petid'];

// Billplz API Configuration
$api_key = 'e63f94a5-2409-4b22-9628-0936bc04ecc8'; // Replace with your actual API key
$collection_id = 'i0arywhn'; // Replace with your collection ID
$host = 'https://www.billplz-sandbox.com/api/v3/bills'; // Use sandbox for testing

// For production, use:
// $host = 'https://www.billplz.com/api/v3/bills';

$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'mobile' => $phone,
    'name' => $name,
    'amount' => $amount * 100, // Convert to cents (RM 50.00 = 5000 cents)
    'description' => 'Donation for Pet #' . $petid,
    'callback_url' => "https://youcanyouup.com.my/pawpal_kz/pawpal/api/return_url",
    'redirect_url' => "https://youcanyouup.com.my/pawpal_kz/pawpal/api/payment_update.php?userid=$userid&email=$email&name=$name&phone=$phone&amount=$amount&petid=$petid" 
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data)); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

// Return JSON response for Flutter to parse
header('Content-Type: application/json');
echo json_encode($bill);

// idk why but this cause error
// header("Location: {$bill['url']}");
?>
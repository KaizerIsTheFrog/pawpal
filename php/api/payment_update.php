<?php
//error_reporting(0);
include_once("dbconnect.php");

$email = $_GET['email'];
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$userid = $_GET['userid'];
$petid = $_GET['petid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus == "true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];

$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
$signed = hash_hmac('sha256', $signing, '64295bb011713d92b207a0b945e34bdbe0c5f0068b8d42d8a1683614052841cbc325b1eb5d3a922fd09687c7b42a068f9530f5d653c49af17f79f702ff6ac2a0');

if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
    
        //insert donation to database
        $description = addslashes("Money donation of RM $amount via Billplz - Receipt: $receiptid");
        $sqlinsertdonation = "INSERT INTO `tbl_donations` (`pet_id`, `donator_user_id`, `donation_type`, `amount`, `description`) VALUES ('$petid', '$userid', 'Money', '$amount', '$description')";
        
        if ($conn->query($sqlinsertdonation) === TRUE){
            //print receipt for success transaction
            echo "
            <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
            <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
            <body>
            <center><h4>Payment Receipt</h4></center>
            <table class='w3-table w3-striped'>
            <th>Item</th><th>Description</th>
            <tr><td>Receipt ID</td><td>$receiptid</td></tr>
            <tr><td>Donor Name</td><td>$name</td></tr>
            <tr><td>Email</td><td>$email</td></tr>
            <tr><td>Phone</td><td>$phone</td></tr>
            <tr><td>Pet ID</td><td>#$petid</td></tr>
            <tr><td>Donation Amount</td><td class='w3-text-green'><b>RM $amount</b></td></tr>
            <tr><td>Payment Status</td><td class='w3-text-green'>$paidstatus</td></tr>
            <tr><td>Payment Date</td><td>".date('d M Y, h:i A')."</td></tr>
            </table><br>
            <div class='w3-panel w3-pale-green w3-border w3-border-green'>
                <p><b>Thank you for your donation!</b></p>
                <p>Your generous contribution will help pets in need.</p>
            </div>
            </body>
            </html>";
        }else{
            echo "
            <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
            <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
            <body>
            <center><h4>Payment Receipt</h4></center>
            <table class='w3-table w3-striped'>
            <th>Item</th><th>Description</th>
            <tr><td>Receipt ID</td><td>$receiptid</td></tr>
            <tr><td>Name</td><td>$name</td></tr>
            <tr><td>Email</td><td>$email</td></tr>
            <tr><td>Phone</td><td>$phone</td></tr>
            <tr><td>Amount</td><td>RM $amount</td></tr>
            <tr><td>Status</td><td class='w3-text-red'>Database Error</td></tr>
            </table><br>
            <div class='w3-panel w3-pale-red w3-border w3-border-red'>
                <p><b>Payment successful but failed to record donation.</b></p>
                <p>Please contact support with Receipt ID: $receiptid</p>
            </div>
            </body>
            </html>";
        }
    }
    else 
    {
        //print receipt for failed transaction
        echo "
        <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
        <body>
        <center><h4>Payment Receipt</h4></center>
        <table class='w3-table w3-striped'>
        <th>Item</th><th>Description</th>
        <tr><td>Receipt ID</td><td>$receiptid</td></tr>
        <tr><td>Name</td><td>$name</td></tr>
        <tr><td>Email</td><td>$email</td></tr>
        <tr><td>Phone</td><td>$phone</td></tr>
        <tr><td>Amount</td><td>RM $amount</td></tr>
        <tr><td>Payment Status</td><td class='w3-text-red'>$paidstatus</td></tr>
        </table><br>
        <div class='w3-panel w3-pale-red w3-border w3-border-red'>
            <p><b>Payment was not completed.</b></p>
            <p>No charges were made to your account.</p>
        </div>
        </body>
        </html>";
    }
}else{
    //signature verification failed
    echo "
    <html><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
    <body>
    <center><h4>Security Error</h4></center>
    <div class='w3-panel w3-pale-red w3-border w3-border-red'>
        <p><b>Invalid payment signature.</b></p>
        <p>Transaction rejected for security reasons.</p>
    </div>
    </body>
    </html>";
}
?>
<?php
    $servername = "localhost";
    $username = "youcapfu_pawpal_kz";
    $password = "s!T1.q{=(+t7";
    $dbname = "youcapfu_pawpal_db_kz";
    // $port = 3307;

    // Create connection
    // $conn = new mysqli($servername, $username, $password, $dbname, $port);
    $conn = new mysqli($servername, $username, $password, $dbname);
    
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>
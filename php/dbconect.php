<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pawpal_db";
$port = 3307;

// create conn
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Check connection
if ($conn->connect_error) {
    // die() sends plain text output and terminates, which is usually fine for a failed connection
    die("Connection failed: " . $conn->connect_error);
}
?>
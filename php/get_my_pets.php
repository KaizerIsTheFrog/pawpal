<?php
    header("Access-Control-Allow-Origin: *"); // running as chrome app

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        include 'dbconnect.php';
        
        $results_per_page = 10;
        if ( isset( $_GET[ 'curpage' ] ) ) {
            $curpage = ( int )$_GET[ 'curpage' ];
        } else {
            $curpage = 1;
        }
        $page_first_result = ( $curpage - 1 ) * $results_per_page;

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
        

        $result = $conn->query($sqlloadservices);
        $number_of_result = $result->num_rows;
        $number_of_page = ceil( $number_of_result / $results_per_page );

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
        $response = array('status' => 'failed');
        sendJsonResponse($response);
        exit();
    }

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
    exit(); 
}
?>
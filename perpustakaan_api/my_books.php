<?php
include 'koneksi.php';
header('Content-Type: application/json');

$data = [];

if (!$conn) {
    echo json_encode(["error" => "Koneksi gagal"]);
    exit;
}

$sql = "SELECT 
            b.*, 
            br.id AS borrowing_id 
        FROM borrowings br
        INNER JOIN books b ON br.book_id = b.id
        WHERE br.user_id = 1";

$query = mysqli_query($conn, $sql);

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data[] = $row;
    }
}

echo json_encode($data);
exit;
?>
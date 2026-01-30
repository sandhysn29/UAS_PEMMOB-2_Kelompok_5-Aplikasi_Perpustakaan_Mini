<?php
header('Content-Type: application/json');
include 'koneksi.php';

if (!isset($_POST['book_id'])) {
    echo json_encode(["success" => false]);
    exit;
}

$book_id = $_POST['book_id'];
$user_id = 1;

$update = mysqli_query(
    $conn,
    "UPDATE books SET stock = stock - 1 
     WHERE id = $book_id AND stock > 0"
);

if (mysqli_affected_rows($conn) > 0) {

    mysqli_query(
        $conn,
        "INSERT INTO borrowings (user_id, book_id) 
         VALUES ($user_id, $book_id)"
    );

    echo json_encode(["success" => true]);

} else {
    echo json_encode(["success" => false]);
}
?>
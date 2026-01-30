<?php
include 'koneksi.php';
header('Content-Type: application/json');

$data = [];

if (!$conn) {
  echo json_encode($data);
  exit;
}

$query = mysqli_query($conn, "SELECT * FROM books");

if ($query) {
  while ($row = mysqli_fetch_assoc($query)) {
    $data[] = $row;
  }
}

echo json_encode($data);
exit;
?>
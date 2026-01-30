<?php
include 'koneksi.php';

$title  = $_POST['title'] ?? '';
$author = $_POST['author'] ?? '';
$year   = $_POST['year'] ?? '';
$reason = $_POST['reason'] ?? '';
$user_id = $_POST['user_id'] ?? 1;

if ($title == '' || $author == '') {
  echo json_encode([
    "success" => false,
    "message" => "Judul dan penulis wajib diisi"
  ]);
  exit;
}

$query = "INSERT INTO book_requests (user_id, title, author, year, reason)
          VALUES ('$user_id', '$title', '$author', '$year', '$reason')";

$result = mysqli_query($conn, $query);

if ($result) {
  echo json_encode([
    "success" => true,
    "message" => "Usulan berhasil ditambahkan"
  ]);
} else {
  echo json_encode([
    "success" => false,
    "message" => "Gagal menyimpan usulan"
  ]);
}
?>
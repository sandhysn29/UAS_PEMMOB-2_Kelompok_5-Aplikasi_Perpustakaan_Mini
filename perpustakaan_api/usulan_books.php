<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');
require_once 'koneksi.php';

if (!isset($conn) || !$conn) {
    echo json_encode(["success" => false, "message" => "Variabel \$conn tidak terbaca. Cek koneksi.php"]);
    exit;
}

$data = [];

$sql = "SELECT id, title, author FROM book_requests ORDER BY id DESC";
$query = $conn->query($sql);

if (!$query) {
    echo json_encode(["success" => false, "message" => "Query Error: " . $conn->error]);
    exit;
}

while ($row = $query->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
$conn->close();
exit;
?>
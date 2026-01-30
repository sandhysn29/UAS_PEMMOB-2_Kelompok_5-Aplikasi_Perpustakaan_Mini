<?php
header("Content-Type: application/json");
error_reporting(E_ALL);
ini_set('display_errors', 1);

include 'koneksi.php';

if (!isset($_POST['book_id'], $_POST['user_id'])) {
    echo json_encode([
        "success" => false,
        "message" => "POST kosong"
    ]);
    exit;
}

$book_id = $_POST['book_id'];
$user_id = $_POST['user_id'];

/* 1️⃣ CEK APAKAH BUKU ADA DI borrowings */
$cek = mysqli_query(
    $conn,
    "SELECT * FROM borrowings WHERE book_id='$book_id' AND user_id='$user_id'"
);

if (!$cek) {
    echo json_encode([
        "success" => false,
        "message" => "Query error",
        "error" => mysqli_error($conn)
    ]);
    exit;
}

if (mysqli_num_rows($cek) == 0) {
    echo json_encode([
        "success" => false,
        "message" => "Buku tidak ditemukan di pinjaman"
    ]);
    exit;
}

/* 2️⃣ HAPUS DATA PINJAMAN */
mysqli_query(
    $conn,
    "DELETE FROM borrowings WHERE book_id='$book_id' AND user_id='$user_id'"
);

/* 3️⃣ TAMBAH STOK BUKU */
mysqli_query(
    $conn,
    "UPDATE books SET stock = stock + 1 WHERE id='$book_id'"
);

echo json_encode([
    "success" => true,
    "message" => "Buku berhasil dikembalikan"
]);
?>
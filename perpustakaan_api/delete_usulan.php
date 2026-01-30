<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');
require_once 'koneksi.php';

$id = isset($_POST['id']) ? intval($_POST['id']) : null;

if ($id === null) {
    echo json_encode(["success"=>false,"message"=>"ID usulan tidak diberikan"]);
    exit;
}

$cekSql = "SELECT * FROM book_requests WHERE id = ?";
$stmtCek = $conn->prepare($cekSql);
$stmtCek->bind_param("i", $id);
$stmtCek->execute();
$result = $stmtCek->get_result();
if ($result->num_rows === 0) {
    echo json_encode(["success"=>false,"message"=>"Usulan tidak ditemukan"]);
    $stmtCek->close();
    $conn->close();
    exit;
}

$delSql = "DELETE FROM book_requests WHERE id = ?";
$stmtDel = $conn->prepare($delSql);
$stmtDel->bind_param("i", $id);

if ($stmtDel->execute()) {
    echo json_encode(["success"=>true,"message"=>"Usulan berhasil dihapus"]);
} else {
    echo json_encode(["success"=>false,"message"=>"Gagal menghapus usulan: ".$stmtDel->error]);
}

$stmtCek->close();
$stmtDel->close();
$conn->close();
exit;
?>
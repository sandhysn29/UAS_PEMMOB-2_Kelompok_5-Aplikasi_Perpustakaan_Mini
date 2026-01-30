<?php
include 'koneksi.php';

$name     = $_POST['name'] ?? '';
$email    = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if ($name == '' || $email == '' || $password == '') {
  echo json_encode([
    "status" => "error",
    "message" => "Semua field wajib diisi"
  ]);
  exit;
}

$check = $conn->query("SELECT id FROM users WHERE email = '$email'");
if ($check->num_rows > 0) {
  echo json_encode([
    "status" => "error",
    "message" => "Email sudah terdaftar"
  ]);
  exit;
}

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

$query = "INSERT INTO users (name, email, password)
          VALUES ('$name', '$email', '$hashedPassword')";

if ($conn->query($query)) {
  echo json_encode([
    "status" => "success",
    "message" => "Registrasi berhasil"
  ]);
} else {
  echo json_encode([
    "status" => "error",
    "message" => "Registrasi gagal"
  ]);
}
?>
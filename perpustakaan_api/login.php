<?php
include 'koneksi.php';

$email = $_POST['email'];
$password = $_POST['password'];

$query = "SELECT * FROM users WHERE email='$email'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
  $user = $result->fetch_assoc();

  if (password_verify($password, $user['password'])) {
    echo json_encode([
      "status" => "success",
      "user" => [
        "id" => $user['id'],
        "name" => $user['name'],
        "email" => $user['email']
      ]
    ]);
  } else {
    echo json_encode(["status" => "error", "message" => "Password salah"]);
  }
} else {
  echo json_encode(["status" => "error", "message" => "Email tidak ditemukan"]);
}
?>
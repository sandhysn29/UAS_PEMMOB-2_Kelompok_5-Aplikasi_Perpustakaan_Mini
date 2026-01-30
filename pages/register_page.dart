import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    var url = Uri.parse("http://10.0.2.2/perpustakaan_api/register.php");

    var response = await http.post(
      url,
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    var data = json.decode(response.body);

    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil, silakan login")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Registrasi gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

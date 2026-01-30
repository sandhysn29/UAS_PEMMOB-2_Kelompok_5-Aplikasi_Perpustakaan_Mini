import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan_app/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    var url = Uri.parse("http://10.0.2.2/perpustakaan_api/login.php");

    var response = await http.post(
      url,
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    var data = json.decode(response.body);

    if (data['status'] == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLogin', true);
      prefs.setString('name', data['user']['name']);
      prefs.setString('user_id', data['user']['id'].toString());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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

            ElevatedButton(onPressed: loginUser, child: const Text('Login')),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterPage()),
                );
              },
              child: const Text("Belum punya akun? Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}

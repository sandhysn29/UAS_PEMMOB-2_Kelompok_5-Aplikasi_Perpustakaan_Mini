import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Berhasil Login')),
      body: Center(child: Text('Login sukses 🎉')),
    );
  }
}
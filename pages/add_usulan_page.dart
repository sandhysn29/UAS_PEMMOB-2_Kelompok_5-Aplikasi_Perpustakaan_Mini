import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUsulanPage extends StatefulWidget {
  @override
  State<AddUsulanPage> createState() => _AddUsulanPageState();
}

class _AddUsulanPageState extends State<AddUsulanPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  bool isLoading = false;

  Future<void> submitUsulan() async {
    if (titleController.text.isEmpty || authorController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Judul dan penulis wajib diisi")));
      return;
    }

    setState(() => isLoading = true);

    var url = Uri.parse("http://10.0.2.2/perpustakaan_api/add_usulan.php");

    var response = await http.post(
      url,
      body: {
        "title": titleController.text,
        "author": authorController.text,
        "year": yearController.text,
        "reason": reasonController.text,
        "user_id": "1",
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Usulan buku berhasil dikirim")));
      Navigator.pop(context, {
        "title": titleController.text,
        "author": authorController.text,
        "year": yearController.text,
        "reason": reasonController.text,
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengirim usulan")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usulan Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Judul Buku",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: "Penulis",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tahun Terbit (opsional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Alasan Usulan",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            ElevatedButton(
              onPressed: isLoading ? null : submitUsulan,
              child: Text(isLoading ? "Mengirim..." : "Kirim Usulan"),
            ),
          ],
        ),
      ),
    );
  }
}

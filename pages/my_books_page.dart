import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_buku.dart';
import 'add_usulan_page.dart';

class MyBooksPage extends StatefulWidget {
  final VoidCallback? onDataChanged;
  const MyBooksPage({Key? key, this.onDataChanged}) : super(key: key);

  @override
  State<MyBooksPage> createState() => MyBooksPageState();
}

class MyBooksPageState extends State<MyBooksPage> {
  List books = [];
  List usulanBooks = [];
  bool isLoadingUsulan = false;

  @override
  void initState() {
    super.initState();
    fetchMyBooks();
    fetchUsulanBooks();
  }

  Future<void> fetchMyBooks() async {
    var url = Uri.parse("http://10.0.2.2/perpustakaan_api/my_books.php");
    var response = await http.get(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = json.decode(response.body);
      setState(() => books = (decoded is List) ? decoded : []);
    } else {
      setState(() => books = []);
    }
  }

  Future<void> fetchUsulanBooks() async {
    setState(() => isLoadingUsulan = true);
    var url = Uri.parse("http://10.0.2.2/perpustakaan_api/usulan_books.php");
    var response = await http.get(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = json.decode(response.body);
      setState(() {
        if (decoded is List) {
          usulanBooks = decoded;
        } else if (decoded is Map && decoded['success'] == false) {
          usulanBooks = [];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(decoded['message'] ?? 'Gagal memuat usulan'),
            ),
          );
        } else {
          usulanBooks = [];
        }
        isLoadingUsulan = false;
      });
    } else {
      setState(() {
        usulanBooks = [];
        isLoadingUsulan = false;
      });
    }
  }

  Widget buildBookCard(Map book) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          book['title'] ?? 'Tanpa Judul',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(book['author'] ?? '-'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailBukuPage(
                book: book,
                onReturned: () {
                  widget.onDataChanged?.call();
                },
              ),
            ),
          );
          if (result == true) fetchMyBooks();
        },
      ),
    );
  }

  Widget buildUsulanCard(Map book, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          book['title'] ?? 'Tanpa Judul',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(book['author'] ?? '-'),
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: Colors.redAccent),
          onPressed: () => cancelUsulan(book['id']),
        ),
      ),
    );
  }

  Future<void> cancelUsulan(dynamic id) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Batalkan Usulan?"),
        content: Text("Apakah Anda yakin ingin membatalkan usulan buku ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ya"),
          ),
        ],
      ),
    );

    if (!confirmed) return;

    setState(() => isLoadingUsulan = true);

    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2/perpustakaan_api/delete_usulan.php"),
        body: {'id': id.toString()},
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await fetchUsulanBooks(); // refetch dari database
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usulan dibatalkan"))
          );
        } else {
          setState(() => isLoadingUsulan = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message']))
          );
        }
      } else {
        setState(() => isLoadingUsulan = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membatalkan usulan"))
        );
      }
    } catch (e) {
      setState(() => isLoadingUsulan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e"))
      );
    }
  }

  Widget buildSection(
    String title,
    List list, {
    bool isBorrowed = true,
    bool showAddButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          isLoadingUsulan && !isBorrowed
              ? Center(child: CircularProgressIndicator())
              : list.isEmpty
                  ? Text(
                      isBorrowed
                          ? "Belum ada buku dipinjam"
                          : "Belum ada usulan buku",
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return isBorrowed
                            ? buildBookCard(list[index])
                            : buildUsulanCard(list[index], index);
                      },
                    ),
          if (showAddButton)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final newUsulan = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddUsulanPage()),
                  );
                  if (newUsulan != null) {
                    await fetchUsulanBooks();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Usulan berhasil"))
                    );
                  }
                },
                icon: Icon(Icons.add),
                label: Text("Ajukan Usulan Buku"),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSection(
            "📚 Buku yang Dipinjam",
            books,
            isBorrowed: true,
          ),
          buildSection(
            "📝 Usulan Buku",
            usulanBooks,
            isBorrowed: false,
            showAddButton: true,
          ),
        ],
      ),
    );
  }

}
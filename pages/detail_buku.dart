import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailBukuPage extends StatefulWidget {
  final Map book;
  final VoidCallback onReturned;

  const DetailBukuPage({Key? key, required this.book, required this.onReturned})
    : super(key: key);

  @override
  State<DetailBukuPage> createState() => _DetailBukuPageState();
}

class _DetailBukuPageState extends State<DetailBukuPage> {
  late bool isBorrowed;

  @override
  void initState() {
    super.initState();
    isBorrowed =
        int.parse(widget.book['stock'].toString()) <
        int.parse(widget.book['total_stock'].toString());
  }

  @override
  Widget build(BuildContext context) {
    bool isStockFull = widget.book['stock'] == widget.book['total_stock'];

    return Scaffold(
      appBar: AppBar(title: Text(widget.book['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.book['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Penulis: ${widget.book['author']}"),
            const SizedBox(height: 8),
            Text("Kategori: ${widget.book['category']}"),
            const SizedBox(height: 8),
            Text("Stok: ${widget.book['stock']}"),
            const SizedBox(height: 8),
            Text(
              isBorrowed ? "Status: Dipinjam" : "Status: Tersedia",
              style: TextStyle(
                color: isBorrowed ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 32),

            Row(
              children: [
                /// ===== PINJAM BUKU =====
                Expanded(
                  child: ElevatedButton(
                    onPressed: isBorrowed
                        ? null
                        : () async {
                            var url = Uri.parse(
                              "http://10.0.2.2/perpustakaan_api/borrow_book.php",
                            );
                            var response = await http.post(
                              url,
                              body: {
                                "book_id": widget.book['id'].toString(),
                                "user_id": "1",
                              },
                            );

                            var result = json.decode(response.body);
                            if (result['success']) {
                              setState(() {
                                isBorrowed = true;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Buku berhasil dipinjam"),
                                ),
                              );

                              widget.onReturned();
                              Navigator.pop(context, true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBorrowed
                          ? Colors.grey[400]
                          : Colors.blue,
                      foregroundColor: isBorrowed
                          ? Colors.grey[700]
                          : Colors.white,
                    ),
                    child: Text(isBorrowed ? "Dipinjam" : "Pinjam Buku"),
                  ),
                ),

                const SizedBox(width: 12),

                /// ===== KEMBALIKAN =====
                Expanded(
                  child: ElevatedButton(
                    onPressed: isStockFull
                        ? null
                        : () async {
                            var url = Uri.parse(
                              "http://10.0.2.2/perpustakaan_api/return_book.php",
                            );
                            var response = await http.post(
                              url,
                              body: {
                                "book_id": widget.book['id'].toString(),
                                "user_id": "1",
                              },
                            );

                            var result = json.decode(response.body);
                            if (result['success']) {
                              setState(() {
                                isBorrowed = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Buku berhasil dikembalikan"),
                                ),
                              );

                              Navigator.pop(context, true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isStockFull
                          ? Colors.grey[300]
                          : Colors.green,
                      foregroundColor: isStockFull
                          ? Colors.black54
                          : Colors.white,
                    ),
                    child: Text(isStockFull ? "Stok Penuh" : "Kembalikan"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

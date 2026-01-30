import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_buku.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List books = [];
  List filteredBooks = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    var url = Uri.parse("http://10.0.2.2/perpustakaan_api/get_books.php");
    var response = await http.get(url);

    setState(() {
      books = json.decode(response.body);
      filteredBooks = List.from(books);
    });
  }

  void searchBook(String query) {
    final result = books.where((book) {
      final title = book['title'].toString().toLowerCase();
      final author = book['author'].toString().toLowerCase();
      final category = book['category'].toString().toLowerCase();

      final input = query.toLowerCase();

      return title.contains(input) ||
          author.contains(input) ||
          category.contains(input);
    }).toList();

    setState(() {
      filteredBooks = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari buku...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: searchBook,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              final stock = int.parse(book['stock']);

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    book['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${book['author']} • ${book['category']}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stok: $stock',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: stock == 0 ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stock == 0 ? 'HABIS' : 'TERSEDIA',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailBukuPage(
                          book: book,
                          onReturned: () {},
                        ),
                      ),
                    ).then((_) {
                      fetchBooks();
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

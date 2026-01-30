import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Aplikasi
          const Text(
            '📚 Aplikasi Perpustakaan Digital',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Deskripsi Aplikasi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Text(
              'Aplikasi ini merupakan platform perpustakaan digital yang memungkinkan pengguna untuk meminjam, mengusulkan, dan melihat status buku secara real-time. Semua proses dilakukan melalui aplikasi mobile untuk kenyamanan pengguna.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),

          // Kelompok
          const Text(
            'Kelompok:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('- Derry Rusyad Nurdin (23552011456)'),
                Text('- Neng Nova Siti Fathonah (23552011455)'),
                Text('- Hilwa Kazhimah Khairunnisa (23552011399)'),
                Text('- Sandhy Safarudin Nurdiansyah (23552011464)'),
                Text('- Wafiq Salma Aulia (23552011427)'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Center(
            child: Text(
              '© 2026 - Universitas Teknologi Bandung\nPemrograman Mobile 2',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

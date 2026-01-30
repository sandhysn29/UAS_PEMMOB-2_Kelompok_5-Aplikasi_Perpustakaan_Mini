# 📱 Aplikasi Perpustakaan Mini

Aplikasi mobile berbasis **Flutter** yang digunakan untuk mengelola data informasi (CRUD) dengan sistem autentikasi pengguna dan penyimpanan data menggunakan **MySQL**.

Aplikasi ini dibuat untuk memenuhi **UAS Pemrograman Mobile 2**.

---

## 🎯 Tujuan Aplikasi
- Memberikan kemudahan pengguna dalam mengelola data informasi
- Menerapkan konsep autentikasi (Login & Register)
- Mengimplementasikan CRUD, navigasi, dan integrasi database

---

## ✨ Fitur Aplikasi

### 🔐 Autentikasi

Fitur register digunakan untuk mendaftarkan pengguna baru dengan mengirimkan data nama, email, dan password ke API berbasis PHP menggunakan metode HTTP POST. Setelah registrasi berhasil, pengguna diarahkan kembali ke halaman login.

- Login pengguna
```Future<void> loginUser() async {
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
  }
}
```
- Inputan Form Login pengguna
```
TextField(
  controller: emailController,
  decoration: const InputDecoration(labelText: 'Email'),
),

TextField(
  controller: passwordController,
  decoration: const InputDecoration(labelText: 'Password'),
  obscureText: true,
),

ElevatedButton(
  onPressed: loginUser,
  child: const Text('Login'),
),
```

- Register pengguna baru
```
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
  }
}
```

- Inputan Form Register
```
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

ElevatedButton(
  onPressed: registerUser,
  child: const Text('Register'),
),
```

### 📋 Manajemen Data Informasi

Fitur ini menampilkan daftar buku dari database menggunakan ListView. Data diambil dari API berbasis PHP menggunakan metode HTTP GET, lalu ditampilkan secara dinamis. Aplikasi juga menyediakan fitur pencarian berdasarkan judul, penulis, dan kategori.

- Tambah data informasi (Create)
```
Future<void> submitUsulan() async {
  if (titleController.text.isEmpty || authorController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Judul dan penulis wajib diisi")),
    );
    return;
  }

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

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Usulan buku berhasil dikirim")),
    );
    Navigator.pop(context);
  }
}
```

- Form Input Usulan Buku
```
TextField(
  controller: titleController,
  decoration: InputDecoration(labelText: "Judul Buku"),
),

TextField(
  controller: authorController,
  decoration: InputDecoration(labelText: "Penulis"),
),

TextField(
  controller: yearController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: "Tahun Terbit"),
),
```


- Menampilkan list data menggunakan **ListView**
```
Future<void> fetchBooks() async {
  var url = Uri.parse("http://10.0.2.2/perpustakaan_api/get_books.php");
  var response = await http.get(url);

  setState(() {
    books = json.decode(response.body);
    filteredBooks = List.from(books);
  });
}
```
- Fitur pencarian data (Search)
```
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

TextField(
  decoration: InputDecoration(
    hintText: 'Cari buku...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: searchBook,
),
```
- Melihat detail informasi
```
class DetailBukuPage extends StatefulWidget {
  final Map book;

  const DetailBukuPage({required this.book});
}
```
```
Text(widget.book['title']),
Text("Penulis: ${widget.book['author']}"),
Text("Kategori: ${widget.book['category']}"),
Text("Stok: ${widget.book['stock']}"),
```

### 🧭 Navigasi

Aplikasi menggunakan BottomNavigationBar untuk berpindah antar halaman utama, yaitu Katalog Buku, My Books, dan Profil. Navigasi ini dipadukan dengan IndexedStack agar state halaman tetap tersimpan.

- Sidebar / Bottom Navigation
```
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book),
      label: 'Katalog',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: 'My Books',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
  ],
),
```

### ℹ️ Informasi Aplikasi

Halaman ini menampilkan deskripsi aplikasi, daftar anggota & NPM, serta informasi copyright.

- Halaman About
```
const Text(
  '📚 Aplikasi Perpustakaan Digital',
  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
),

Container(
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
```
- Menampilkan nama anggota & NPM
```
Container(
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
```

- Menampilkan copyright
```
Center(
  child: Text(
    '© 2026 - Universitas Teknologi Bandung\nPemrograman Mobile 2',
    textAlign: TextAlign.center,
  ),
),
```

## 🗂️ Database
- Database: **MySQL**
- Digunakan untuk:
  - Data user
  - Data informasi
- Backend menggunakan PHP & REST API

---

## 📸 Screenshot Aplikasi

> Login  
<img width="357" height="634" alt="image" src="https://github.com/user-attachments/assets/6f770c96-51d7-46ed-831d-c5ee992f4bb4" />

> Register  
<img width="358" height="636" alt="image" src="https://github.com/user-attachments/assets/eb70c73b-7416-40f0-9cfe-4afe03538f80" />

> List View  
<img width="353" height="635" alt="image" src="https://github.com/user-attachments/assets/de900199-41e6-4330-bdc9-9fdcb991d7ab" />

> Detail Informasi  
<img width="354" height="634" alt="image" src="https://github.com/user-attachments/assets/c4d63e0d-36cf-46ec-9380-f8a282cc3f20" />

> About  
<img width="393" height="703" alt="image" src="https://github.com/user-attachments/assets/7529ad31-0efe-4f86-9503-3b4424e21b43" />

---

## 🎥 Video Demo Aplikasi
📽️ **Link Video Demo:**  
👉 

---

## 👥 Anggota Kelompok
- Derry Rusyad Nurdin (23552011456)
- Neng Nova Siti Fathonah (23552011455)
- Hilwa Kazhimah Khairunnisa (23552011399)
- Sandhy Safarudin Nurdiansyah (23552011464)
- Wafiq Salma Aulia (23552011427)

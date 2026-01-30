import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'my_books_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final GlobalKey<HomePageState> homeKey = GlobalKey<HomePageState>();
  final GlobalKey<MyBooksPageState> myBooksKey = GlobalKey<MyBooksPageState>();

  List<Widget> get _pages => [
    HomePage(key: homeKey),
    MyBooksPage(
      key: myBooksKey,
      onDataChanged: () {
        homeKey.currentState?.fetchBooks();
      },
    ),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Katalog Buku'
              : _currentIndex == 1
              ? 'My Books'
              : 'Profil',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            myBooksKey.currentState?.fetchMyBooks();
          }

          if (index == 0) {
            homeKey.currentState?.fetchBooks();
          }
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

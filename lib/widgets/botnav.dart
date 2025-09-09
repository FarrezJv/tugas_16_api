import 'package:flutter/material.dart';
import 'package:tugas_16_api/views/admin_category.dart';
import 'package:tugas_16_api/views/dashboard.dart';
import 'package:tugas_16_api/views/reviews.dart';
import 'package:tugas_16_api/views/tambah.dart';

class BotnavPage extends StatefulWidget {
  const BotnavPage({super.key});
  static const id = "/Botnav";

  @override
  State<BotnavPage> createState() => _BotnavPageState();
}

class _BotnavPageState extends State<BotnavPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    AdminCategory(),
    ReviewScreen(),
    TambahBrand(),
    // ReviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'review'),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin Feature',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.sign_language),
          //   label: 'Daftar',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF8A6BE4),
        unselectedItemColor: Colors.black,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}

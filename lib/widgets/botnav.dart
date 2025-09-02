import 'package:flutter/material.dart';
import 'package:tugas_16_api/views/dashboard.dart';
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
    TambahBrand(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Admin Feature',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.sign_language),
          //   label: 'Daftar',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
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

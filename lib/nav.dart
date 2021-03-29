import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bijou/searchpage.dart';
import 'package:bijou/signinpage.dart';
import 'package:bijou/authservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Text('Discover'),
    SearchPage(),
    Text('Boards'),
    SignInPage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.pink,
        backgroundColor: Colors.pink,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline, color: Colors.grey),
            title: Text('Discover'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.push_pin, color: Colors.grey),
            title: Text('Boards'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, color: Colors.grey),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}

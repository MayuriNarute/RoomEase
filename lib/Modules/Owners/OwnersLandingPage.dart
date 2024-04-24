import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ss/Modules/Owners/profile.dart';

import '../../Authentication/Presentation/registerScreen.dart';
import 'addProperty.dart';
import 'booking.dart';
import 'listedProperties.dart';

class OwnersLanding extends StatefulWidget {
  const OwnersLanding({super.key});

  @override
  State<OwnersLanding> createState() => _OwnersLandingState();
}

class _OwnersLandingState extends State<OwnersLanding> {
  int _selectedIndex = 0;
  static  List<Widget> _pages = <Widget>[
    ListedProperties(),
    AddProperty(),
    OwnersBookingPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,

        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Apartment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Requests',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      )
    );
  }
}

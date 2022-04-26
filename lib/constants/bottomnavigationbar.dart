import 'package:expensenote/Pages/hivetutorial.dart';
import 'package:expensenote/Pages/profile.dart';
import 'package:expensenote/Pages/transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Pages/myhomepage.dart';

class BottomBar {
  List pagelist = [MyHomePage(), Transactions(), Profile(), HiveTutotial()];
  int _bottomNavIndex = 0;
  BottomBar(int index) {
    _bottomNavIndex = index;
  }

  Widget BottomBarWidget() {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue),
        BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
            backgroundColor: Colors.blue),
        const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue),
        const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'stocks',
            backgroundColor: Colors.blue),
      ],
      selectedItemColor: Colors.black,
      iconSize: 40,
      currentIndex: _bottomNavIndex,
      onTap: (index) {
        Get.off(pagelist[index], transition: Transition.circularReveal);
        _bottomNavIndex = index;
      },
      // onTap: _onItemTapped,
      type: BottomNavigationBarType.shifting,
    );
  }
}

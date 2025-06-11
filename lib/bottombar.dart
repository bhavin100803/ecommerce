import 'package:flutter/material.dart';

import 'cartpage.dart';
import 'dashboardscreen.dart';

class MainBottomNavScreen extends StatefulWidget {
  @override
  _MainBottomNavScreenState createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    DashboardScreen(),
    extra(),
    FavoritesScreen(),
    CartPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex = 0; // Navigate to Home (Dashboard)
          });
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.home),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.grid_view,
                        color: currentIndex == 1 ? Colors.white : Colors.grey),
                    onPressed: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                  ),
                  SizedBox(width: 10,),
                  IconButton(
                    icon: Icon(Icons.favorite,
                        color: currentIndex == 2 ? Colors.deepOrange : Colors.grey),
                    onPressed: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart,
                        color: currentIndex == 3 ? Colors.deepOrange : Colors.grey),
                    onPressed: () {
                      setState(() {
                        currentIndex = 3;
                      });
                    },
                  ),
                  SizedBox(width: 10,),
                  IconButton(
                    icon: Icon(Icons.person,
                        color: currentIndex == 4 ? Colors.deepOrange : Colors.grey),
                    onPressed: () {
                      setState(() {
                        currentIndex = 4;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

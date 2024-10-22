import 'package:flutter/material.dart';
import 'package:meal_app/Screens/home_screen.dart';
import 'package:meal_app/Screens/Categories_screen.dart';
import 'package:meal_app/Screens/random_meal.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int index = 0;
  List<Widget> screens = [
    HomeScreen(),
    CategoriesScreen(),
    RandomMeal(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          index = value;
          setState(() {

          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
              ),
              label: "Categories"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.sunny,
              ),
              label: "Search"
          ),
        ],
      ),
      body: screens[index],
    );
  }
}
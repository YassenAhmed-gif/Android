import 'package:flutter/material.dart';
import 'package:meal_app/Screens/home_screen.dart';
import 'package:meal_app/Screens/Categories_screen.dart';
import 'package:meal_app/Screens/random_meal.dart';
import 'package:meal_app/shared/cubit/egyptian_cubit/Meal_cubit.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List<Widget> screens = [
    HomeScreen(),
    CategoriesScreen(),
    RandomMeal(),
  ];

  PageController pageCntl = PageController();
  void dispose(){
    super.dispose();
    pageCntl.dispose();
  }
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
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
                Icons.set_meal_outlined,
              ),
              label: "AI feature"
          ),
        ],
      ),
      body: screens[index],
    );
  }
}
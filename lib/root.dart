import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/screens/cart_screen.dart';
import 'package:hungry/features/favorite/screen/favorite_screen.dart';
import 'package:hungry/features/favorite/data/favorite_model.dart';
import 'package:hungry/features/home/screens/home_screen.dart';
import 'package:hungry/features/orderHistory/screens/order_history_screen.dart';
import 'package:liquid_navbar/liquid_navbar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'features/auth/screens/profile_screen.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController pageController;
  late List<Widget> screens;
  int selectedIndex = 0;

  void toggle(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    screens = [HomeScreen(), FavoriteScreen(), CartScreen(), OrderHistoryScreen(), ProfileScreen()];
    pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(physics: NeverScrollableScrollPhysics(), controller: pageController, children: screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkCoffee.withOpacity(0.5), AppColors.secondary.withOpacity(0.5)],
              ),
            ),
            padding: EdgeInsets.all(10),
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: buildBottomNavigationBar()),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (index) {
        toggle(index);
        pageController.jumpToPage(selectedIndex);
      },
selectedItemColor: AppColors.primary,
      unselectedLabelStyle: TextStyle(color: AppColors.primary),
      elevation: 0,
      currentIndex: selectedIndex,
      showUnselectedLabels: false,
      unselectedIconTheme: IconThemeData(color: AppColors.basic, fill: 0.2),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      items: [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), label: "Fav"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.local_restaurant), label: "Order History"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), label: "Profile"),
      ],
    );
  }
}

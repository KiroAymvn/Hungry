import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/cubit/cart_cubit.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/cart/screens/cart_screen.dart';
import 'package:hungry/features/favorite/cubit/favorite_cubit.dart';
import 'package:hungry/features/favorite/data/favorite_repo.dart';
import 'package:hungry/features/favorite/screen/favorite_screen.dart';
import 'package:hungry/features/home/cubit/home_cubit.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/home/screens/home_screen.dart';
import 'package:hungry/features/orderHistory/screens/order_history_screen.dart';

import 'features/auth/screens/profile_screen.dart';

/// Root is the main shell of the app after login.
/// It holds the bottom navigation bar and provides the cubits
/// for every tab screen.
class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  // The five tab screens — defined once to avoid recreating them on each build
  static const List<Widget> _screens = [
    HomeScreen(),
    FavoriteScreen(),
    CartScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // HomeCubit — loads products and handles fav toggle
        BlocProvider(
          create: (_) =>
              HomeCubit(ProductRepo(), FavoriteRepo())..loadHome(),
        ),
        // CartCubit — loads the cart
        BlocProvider(
          create: (_) => CartCubit(CartRepo())..getCart(),
        ),
        // FavoriteCubit — loads the favorites list
        BlocProvider(
          create: (_) => FavoriteCubit(FavoriteRepo())..getFavorites(),
        ),
      ],
      child: Scaffold(
        extendBody: true,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _screens,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.darkCoffee.withOpacity(0.5),
                    AppColors.secondary.withOpacity(0.5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: _buildBottomNavigationBar(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: _onTabTapped,
      selectedItemColor: AppColors.primary,
      unselectedLabelStyle: const TextStyle(color: AppColors.primary),
      elevation: 0,
      currentIndex: _selectedIndex,
      showUnselectedLabels: false,
      unselectedIconTheme:
          const IconThemeData(color: AppColors.basic, fill: 0.2),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart), label: 'Fav'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart), label: 'Cart'),
        BottomNavigationBarItem(
            icon: Icon(Icons.local_restaurant), label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled), label: 'Profile'),
      ],
    );
  }
}

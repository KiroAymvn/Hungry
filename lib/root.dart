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

  static const List<_NavItem> _navItems = [
    _NavItem(icon: CupertinoIcons.house, activeIcon: CupertinoIcons.house_fill, label: 'Home'),
    _NavItem(icon: CupertinoIcons.heart, activeIcon: CupertinoIcons.heart_fill, label: 'Fav'),
    _NavItem(icon: CupertinoIcons.cart, activeIcon: CupertinoIcons.cart_fill, label: 'Cart'),
    _NavItem(icon: Icons.local_restaurant_outlined, activeIcon: Icons.local_restaurant, label: 'Orders'),
    _NavItem(icon: CupertinoIcons.person, activeIcon: CupertinoIcons.person_fill, label: 'Profile'),
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
          create: (_) => HomeCubit(ProductRepo(), FavoriteRepo())..loadHome(),
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
        bottomNavigationBar: _CustomFloatingNavBar(
          selectedIndex: _selectedIndex,
          items: _navItems,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}

// ─── Nav Item Data ──────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ─── Custom Floating Nav Bar ────────────────────────────────────────────────
class _CustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _CustomFloatingNavBar({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkCoffee.withOpacity(0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkCoffee.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  return _NavBarButton(
                    item: items[index],
                    isSelected: index == selectedIndex,
                    onTap: () => onTap(index),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Individual Nav Button ──────────────────────────────────────────────────
class _NavBarButton extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? Colors.white : AppColors.basic,
                size: 24,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

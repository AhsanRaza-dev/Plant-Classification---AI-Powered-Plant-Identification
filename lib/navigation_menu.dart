import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:plant_app/view/home/home_screen.dart';
import 'package:plant_app/view/profile/profile_screen.dart';
import 'package:plant_app/view/results/results_screen.dart';

import 'controllers/color_controller.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final colorController = Get.find<ColorSchemeController>();

    return Scaffold(
      extendBody: true, // Important for the transparent effect
      bottomNavigationBar: Obx(
        () => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colorController.buttonPrimaryColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  );
                }
                return TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: Colors.white, size: 26);
                }
                return IconThemeData(
                  color: Colors.white.withOpacity(0.7),
                  size: 24,
                );
              }),
              indicatorColor: Colors.white.withOpacity(0.15),
            ),
            child: NavigationBar(
              height: 70,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) {
                // Play animation when changing tabs
                _animationController.reset();
                _animationController.forward();
                controller.selectedIndex.value = index;
              },
              animationDuration: const Duration(milliseconds: 800),
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: [
                _buildNavDestination(
                  Iconsax.home,
                  Iconsax.home5,
                  "Home",
                  controller.selectedIndex.value == 0,
                ),
                _buildNavDestination(
                  Icons.auto_awesome_rounded,
                  Icons.auto_awesome,
                  "Models",
                  controller.selectedIndex.value == 1,
                ),
                _buildNavDestination(
                  Iconsax.user,
                  Iconsax.user_tick,
                  "Profile",
                  controller.selectedIndex.value == 3,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: controller.screens[controller.selectedIndex.value],
        );
      }),
    );
  }

  NavigationDestination _buildNavDestination(
    IconData icon,
    IconData selectedIcon,
    String label,
    bool isSelected,
  ) {
    return NavigationDestination(
      icon: Icon(isSelected ? selectedIcon : icon),
      label: label,
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(), // Home Screen
    const AppResult(), // History Page
    const ProfileScreen(), // Profile/Settings Screen
  ];
}

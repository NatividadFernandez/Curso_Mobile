import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            widget.navigationShell.goBranch(value,
                initialLocation: value == widget.navigationShell.currentIndex);
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            label: "Pets",
            selectedIcon: Icon(Icons.pets),
          ),
          NavigationDestination(
            icon: Icon(Icons.location_city_outlined),
            label: "Organizations",
            selectedIcon: Icon(Icons.location_city),
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: "Favorites",
            selectedIcon: Icon(Icons.favorite),
          )
        ],
      ),
    );
  }
}

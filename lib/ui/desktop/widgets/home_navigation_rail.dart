import 'package:flutter/material.dart';

class HomeNavigationRail extends StatefulWidget {
  const HomeNavigationRail({super.key});

  @override
  State<HomeNavigationRail> createState() => _HomeNavigationRailState();
}

class _HomeNavigationRailState extends State<HomeNavigationRail> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labelType: NavigationRailLabelType.selected,
          destinations: const <NavigationRailDestination>[
            NavigationRailDestination(
              icon: Icon(Icons.person),
              selectedIcon: Icon(
                Icons.person,
              ),
              label: Text('Character'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.chat_rounded),
              selectedIcon: Icon(
                Icons.chat_rounded,
              ),
              label: Text('Sessions'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.account_tree_rounded),
              selectedIcon: Icon(
                Icons.account_tree_rounded,
              ),
              label: Text('Model')
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(
                Icons.settings,
              ),
              label: Text('Settings'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.info),
              selectedIcon: Icon(
                Icons.info,
              ),
              label: Text('About'),
            ),
          ],
        ),
      ],
    );
  }
}
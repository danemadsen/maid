import 'package:flutter/material.dart';
import 'package:maid/ui/desktop/widgets/home_navigation_rail.dart';
import 'package:maid/ui/mobile/widgets/appbars/home_app_bar.dart';
import 'package:maid/ui/shared/chat_body.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          HomeNavigationRail(),
          ChatBody()
        ],
      ),
    );
  }
}

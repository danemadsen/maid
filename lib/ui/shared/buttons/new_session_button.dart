import 'package:flutter/material.dart';
import 'package:maid/classes/providers/app_data.dart';

/// A button widget that creates a new [Session].
///
/// This button is used to create a new [Session] in the application.
/// It triggers the [newSession] function from the [AppData] class when pressed.
class NewSessionButton extends StatelessWidget {
  const NewSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: AppData.of(context).newSession,
      child: const Text(
        "New Chat"
      ),
    );
  }
}
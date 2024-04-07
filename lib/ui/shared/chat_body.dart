import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maid/classes/chat_node.dart';
import 'package:maid/providers/character.dart';
import 'package:maid/providers/session.dart';
import 'package:maid/providers/user.dart';
import 'package:maid/static/utilities.dart';
import 'package:maid/ui/mobile/widgets/chat_widgets/chat_field.dart';
import 'package:maid/ui/mobile/widgets/chat_widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final ScrollController _consoleScrollController = ScrollController();
  List<ChatMessageWidget> chatWidgets = [];
  
  @override
  Widget build(BuildContext context) {
    return Consumer3<Session, User, Character>(
      builder: (context, session, user, character, child) {
        Map<Key, ChatRole> history = session.chat.getHistory();
        if (history.isEmpty && character.useGreeting) {
          final newKey = UniqueKey();
          final index = Random().nextInt(character.greetings.length);
          session.chat.add(
            newKey,
            message: Utilities.formatPlaceholders(character.greetings[index], user.name, character.name),
            role: ChatRole.assistant
          );
          history = {newKey: ChatRole.assistant};
        }

        chatWidgets.clear();
        for (var key in history.keys) {
          chatWidgets.add(ChatMessageWidget(
            key: key,
            role: history[key] ?? ChatRole.assistant,
          ));
        }

        return Builder(
          builder: (BuildContext context) => GestureDetector(
            onHorizontalDragEnd: (details) {
              // Check if the drag is towards right with a certain velocity
              if (details.primaryVelocity! > 100) {
                // Open the drawer
                Scaffold.of(context).openDrawer();
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _consoleScrollController,
                    itemCount: chatWidgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return chatWidgets[index];
                    },
                  ),
                ),
                const ChatField(),
              ],
            ),
          ),
        );
      },
    );
  }
}
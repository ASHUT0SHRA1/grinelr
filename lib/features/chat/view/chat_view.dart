import 'package:flutter/material.dart';
import 'package:grinler/features/chat/widget/coming_soon.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const ChatPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: const ComingSoonWidget(),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:yusuf_flutter_test_p1/widgets/chat_widget.dart';
import '../widgets/jarvis_app_bar.dart';
import '../widgets/new_chat_button.dart';
import '../widgets/prompt_suggestion_card.dart';
import '../widgets/examples_list.dart';

class JarvisChatScreen extends StatefulWidget {
  const JarvisChatScreen({super.key});

  @override
  State<JarvisChatScreen> createState() => _JarvisChatScreenState();
}

class _JarvisChatScreenState extends State<JarvisChatScreen> {
  bool showSuggestions = true;

  void handleTypingStarted() {
    if (showSuggestions) {
      setState(() {
        showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          const NewChatButton(),
          const SizedBox(height: 20),
          if (showSuggestions) ...[
            const PromptSuggestionCard(),
            const SizedBox(height: 50),
            const ExamplesList(),
            const SizedBox(height: 20),
          ],
          Expanded(
            child: ChatWidget(
              onTyping: handleTypingStarted, // 👈 pass callback
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yusuf_flutter_test_p1/widgets/jarvis_chat_box.dart';

class ChatWidget extends StatefulWidget {
  final VoidCallback? onTyping; // ✅ Added for typing notification

  const ChatWidget({super.key, this.onTyping});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final AnthropicClient client;

  ChatUser user = ChatUser(id: "0", firstName: "User");
  ChatUser jarvis = ChatUser(id: '1', firstName: "Jarvis");

  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: JarvisChatBox(
        currentUser: user,
        onSend: _sendMessage,
        messages: messages,
        onTextChanged: widget.onTyping, // ✅ Forward callback to JarvisChatBox
      ),
    );
  }

  void _sendMessage(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
    });

    final response = await _sendMessageToAnthropic(message.text);

    setState(() {
      messages.insert(
        0,
        ChatMessage(
          user: jarvis,
          createdAt: DateTime.now(),
          text: response,
        ),
      );
    });
  }

  void _setup() async {
    client = AnthropicClient(apiKey: dotenv.get("ANTHROPIC_API_KEY"));
  }

  Future<String> _sendMessageToAnthropic(String message) async {
    final res = await client.createMessage(
      request: CreateMessageRequest(
        model: Model.model(Models.claude3Haiku20240307),
        messages: [
          Message(
            role: MessageRole.user,
            content: MessageContent.text(
              "You are Jarvis, the user's personal AI assistant. Do not mention Anthropic or Claude. Respond in a helpful, concise, friendly way.",
            ),
          ),
          ...messages.map(
            (e) => Message(
              content: MessageContent.text(e.text),
              role: e.user == user ? MessageRole.user : MessageRole.assistant,
            ),
          ),
          Message(
            content: MessageContent.text(message),
            role: MessageRole.user,
          ),
        ],
        maxTokens: 512,
      ),
    );

    return res.content.text;
  }
}

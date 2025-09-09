import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusuf_flutter_test_p1/models/chat_models.dart';

import 'package:yusuf_flutter_test_p1/state/providers.dart';
import 'package:yusuf_flutter_test_p1/widgets/jarvis_chat_box.dart';

class ChatWidget extends ConsumerStatefulWidget {
  final VoidCallback? onTyping;
  final String? searchQuery;
  
  const ChatWidget({super.key, this.onTyping, this.searchQuery});

  @override
  ConsumerState<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends ConsumerState<ChatWidget> {
  late final AnthropicClient client;

  static const assistantUserId = 'jarvis';
  final ChatUser jarvis = ChatUser(id: assistantUserId, firstName: 'Jarvis');

  bool _callingApi = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    client = AnthropicClient(apiKey: dotenv.get('ANTHROPIC_API_KEY'));
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authStateProvider).asData?.value;
    final currentUser = ChatUser(
      id: authUser?.uid ?? 'guest',
      firstName: authUser?.displayName ?? 'You',
    );
    final messages = ref.watch(currentChatProvider);

    return SafeArea(
      top: false,
      child: JarvisChatBox(
        currentUser: currentUser,
        messages: messages,
        onSend: (m) => _handleSend(m, currentUser),
        onTextChanged: widget.onTyping,
        searchQuery: widget.searchQuery,
        isLoading: _callingApi,
      ),
    );
  }

  Future<void> _handleSend(ChatMessage message, ChatUser currentUser) async {
    if (_callingApi) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please wait for Jarvis to finish.')),
        );
      }
      return;
    }

    ref.read(currentChatProvider.notifier).add(message);
    widget.onTyping?.call();

    setState(() => _callingApi = true);

    String replyText = 'Sorry, something went wrong. Please try again.';
    try {
      replyText = await _sendMessageToAnthropic(
        latestUserMessage: message.text,
        currentUser: currentUser,
        allMessagesNewestFirst: ref.read(currentChatProvider),
      );
      if (replyText.trim().isEmpty) {
        replyText = 'Hmm, I couldn\'t generate a reply.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network/API error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _callingApi = false);
    }

    ref.read(currentChatProvider.notifier).add(
      ChatMessage(
        user: jarvis,
        createdAt: DateTime.now(),
        text: replyText,
      ),
    );
  }

  Future<String> _sendMessageToAnthropic({
    required String latestUserMessage,
    required ChatUser currentUser,
    required List<ChatMessage> allMessagesNewestFirst,
  }) async {
    final chronological = allMessagesNewestFirst.reversed.toList();

    final history = chronological.map((e) {
      final isUser = e.user.id == currentUser.id;
      return Message(
        role: isUser ? MessageRole.user : MessageRole.assistant,
        content: MessageContent.text(e.text),
      );
    }).toList();

    final instruction = Message(
      role: MessageRole.user,
      content: MessageContent.text(
        "You are Jarvis, the user's personal AI assistant. Do not mention Anthropic or Claude. Respond helpfully and concisely.",
      ),
    );

    final latest = Message(
      role: MessageRole.user,
      content: MessageContent.text(latestUserMessage),
    );

    final res = await client.createMessage(
      request: CreateMessageRequest(
        model: Model.model(Models.claude3Haiku20240307),
        messages: [instruction, ...history, latest],
        maxTokens: 512,
      ),
    );

    final text = res.content.text;
    return text.isNotEmpty ? text : ' ';
  }
}
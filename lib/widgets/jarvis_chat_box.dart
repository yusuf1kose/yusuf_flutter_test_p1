import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class JarvisChatBox extends StatefulWidget {
  final List<ChatMessage> messages;
  final ChatUser currentUser;
  final Function(ChatMessage) onSend;
  final VoidCallback? onTextChanged; // ✅ Added this

  const JarvisChatBox({
    super.key,
    required this.messages,
    required this.currentUser,
    required this.onSend,
    this.onTextChanged,
  });

  @override
  State<JarvisChatBox> createState() => _JarvisChatBoxState();
}

class _JarvisChatBoxState extends State<JarvisChatBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DashChat(
            currentUser: widget.currentUser,
            onSend: widget.onSend,
            messages: widget.messages,
            inputOptions: const InputOptions(
              alwaysShowSend: false,
              inputToolbarPadding: EdgeInsets.zero,
              inputToolbarMargin: EdgeInsets.zero,
              inputDecoration: InputDecoration.collapsed(hintText: ''),
            ),
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              )
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Row(
            children: [
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F7),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (_) => widget.onTextChanged?.call(), // ✅ Call typing notifier
                        decoration: const InputDecoration(
                          hintText: "Type here...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic_none_outlined, color: Colors.grey),
                      iconSize: 34,
                      onPressed: () {
                        // TODO: mic action
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF1FA774)),
                      iconSize: 34,
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          widget.onSend(ChatMessage(
                            user: widget.currentUser,
                            createdAt: DateTime.now(),
                            text: text,
                          ));
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.save_outlined, color: Color(0xFF8EF2C7)),
                iconSize: 32,
                onPressed: () {
                  // TODO: Save logic
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

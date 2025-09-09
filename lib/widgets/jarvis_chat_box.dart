import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:yusuf_flutter_test_p1/widgets/Dialogs/save_chat_dialog.dart';
import 'package:yusuf_flutter_test_p1/widgets/custom_message_bubble.dart';
import 'package:yusuf_flutter_test_p1/models/chat_models.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart';

class JarvisChatBox extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  final ChatUser currentUser;
  final Function(ChatMessage) onSend;
  final VoidCallback? onTextChanged;
  final String? searchQuery;
  final bool isLoading;

  const JarvisChatBox({
    super.key,
    required this.messages,
    required this.currentUser,
    required this.onSend,
    this.onTextChanged,
    this.searchQuery,
    this.isLoading = false,
  });

  @override
  ConsumerState<JarvisChatBox> createState() => _JarvisChatBoxState();
}

class _JarvisChatBoxState extends ConsumerState<JarvisChatBox> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  // Speech-to-text
  late final stt.SpeechToText _speech;
  bool _speechReady = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
      debugLogging: false,
    );
    setState(() => _speechReady = available);
  }

  Future<void> _toggleRecording() async {
    if (!_speechReady) {
      await _initSpeech();
      if (!_speechReady) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech engine not available')),
        );
        return;
      }
    }

    if (_speech.isListening || _isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    setState(() => _isListening = true);
    await _speech.listen(
      onResult: _onSpeechResult,
      partialResults: true,
      listenMode: stt.ListenMode.dictation,
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  void _onSpeechResult(stt.SpeechRecognitionResult result) {
    final words = result.recognizedWords;
    _controller.text = words;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    widget.onTextChanged?.call();

    if (result.finalResult) {
      setState(() => _isListening = false);
    }
  }

  void _onSpeechStatus(String status) {
    if (status.toLowerCase().contains('listening')) {
      setState(() => _isListening = true);
    } else if (status.toLowerCase().contains('notlistening')) {
      setState(() => _isListening = false);
    }
  }

  void _onSpeechError(stt.SpeechRecognitionError error) {
    setState(() => _isListening = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mic error: ${error.errorMsg}')),
    );
  }

  Widget _buildLoadingBubble() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jarvis avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF1FA774),
            child: Text(
              'J',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 2),
                  child: Text(
                    'Jarvis',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2B2D33) : const Color(0xFFF2F3F7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Thinking...',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final pageBg = theme.scaffoldBackgroundColor;
    final bubble = isDark ? const Color(0xFF2B2D33) : const Color(0xFFF2F3F7);
    final hint = isDark ? Colors.white60 : Colors.black54;

    return Column(
      children: [
        // ---------- CUSTOM MESSAGE LIST ----------
        Expanded(
          child: widget.messages.isEmpty && !widget.isLoading
              ? const Center(
                  child: Text(
                    'No messages yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  reverse: true, // newest messages at bottom
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                  itemCount: widget.messages.length + (widget.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading bubble at index 0 (top) when loading
                    if (widget.isLoading && index == 0) {
                      return _buildLoadingBubble();
                    }
                    
                    // Adjust index for actual messages when loading
                    final messageIndex = widget.isLoading ? index - 1 : index;
                    final message = widget.messages[messageIndex];
                    return CustomMessageBubble(
                      message: message,
                      currentUser: widget.currentUser,
                      searchQuery: widget.searchQuery,
                    );
                  },
                ),
        ),

        // ---------- CUSTOM COMPOSER ----------
        Material(
          color: pageBg,
          elevation: 0,
          shadowColor: Colors.transparent,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: bubble,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: _isFocused ? const Color(0xFF1FA774) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: (_) => widget.onTextChanged?.call(),
                            onTap: () => setState(() => _isFocused = true),
                            onEditingComplete: () => setState(() => _isFocused = false),
                            onSubmitted: (_) => setState(() => _isFocused = false),
                            maxLines: 4,
                            minLines: 1,
                            cursorColor: cs.primary,
                            decoration: InputDecoration(
                              hintText: 'Type here...',
                              hintStyle: TextStyle(color: hint),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              filled: false,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),

                        if (_isListening)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),

                        IconButton(
                          icon: Icon(
                            _isListening
                                ? Icons.stop_circle_outlined
                                : Icons.mic_none_outlined,
                            color: _isListening
                                ? cs.primary
                                : (isDark ? Colors.white70 : Colors.grey),
                          ),
                          iconSize: 28,
                          onPressed: _toggleRecording,
                        ),

                        IconButton(
                          icon: Icon(Icons.send_rounded, color: cs.primary),
                          iconSize: 30,
                          onPressed: () async {
                            if (_isListening) {
                              await _stopListening();
                            }
                            final text = _controller.text.trim();
                            if (text.isNotEmpty) {
                              widget.onSend(
                                ChatMessage(
                                  user: widget.currentUser,
                                  createdAt: DateTime.now(),
                                  text: text,
                                ),
                              );
                              _controller.clear();
                              setState(() => _isFocused = false);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(
                      Icons.save_outlined,
                      color: isDark
                          ? const Color(0xFF8EF2C7)
                          : const Color(0xFF1FA774),
                    ),
                    iconSize: 28,
                    onPressed: () async {
                      if (widget.messages.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('There is nothing to save yet.'),
                          ),
                        );
                        return;
                      }
                      final title = await showSaveChatDialog(context);
                      if (title == null || title.trim().isEmpty) return;

                      await ref.read(chatSessionsProvider.notifier).saveSession(
                        title: title.trim(),
                        messages: widget.messages,
                      );

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chat saved')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
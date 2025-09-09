import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_models.dart';

class CustomMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatUser currentUser;
  final String? searchQuery;

  const CustomMessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
    this.searchQuery,
  });

  Widget _buildHighlightedText(String text, String? query, Color textColor) {
    if (query == null || query.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;
    
    while (start < text.length) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        // No more matches, add the rest of the text
        spans.add(TextSpan(
          text: text.substring(start),
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ));
        break;
      }

      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ));
      }

      // Add the highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          backgroundColor: Colors.yellow.withOpacity(0.6),
        ),
      ));

      start = index + query.length;
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.user.id == currentUser.id;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Check if this message matches the search query
    final hasMatch = searchQuery != null && 
                    searchQuery!.isNotEmpty && 
                    message.text.toLowerCase().contains(searchQuery!.toLowerCase());

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: hasMatch ? BoxDecoration(
        color: const Color(0xFF1FA774).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ) : null,
      padding: hasMatch ? const EdgeInsets.all(4) : EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // Jarvis avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1FA774),
              child: Text(
                'J',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                    child: Text(
                      message.user.firstName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? const Color(0xFF1FA774) 
                        : (isDark ? const Color(0xFF2B2D33) : const Color(0xFFF2F3F7)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                  ),
                  child: _buildHighlightedText(
                    message.text,
                    searchQuery,
                    isUser 
                        ? Colors.white 
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            // User avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: cs.primary.withOpacity(0.2),
              child: Text(
                currentUser.firstName.isNotEmpty ? currentUser.firstName[0].toUpperCase() : 'U',
                style: GoogleFonts.poppins(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final ChatUser user;
  final DateTime createdAt;
  final String text;

  ChatMessage({
    required this.user,
    required this.createdAt,
    required this.text,
  });
}

class ChatUser {
  final String id;
  final String firstName;
  final String? profileImage;

  ChatUser({
    required this.id,
    required this.firstName,
    this.profileImage,
  });
}
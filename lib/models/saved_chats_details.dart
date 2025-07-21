import 'package:uuid/uuid.dart';

final uuid = Uuid();



class SavedChatsDetails {
  SavedChatsDetails({required this.title, required this.date}) : id = uuid.v4();

  final String id;
  final String title;
  final DateTime date;
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/chat_message_model.dart';

class ChatService extends GetxService {
  final _firestore = FirebaseFirestore.instance;
  
  // Since there is only one user and no auth, we use a fixed ID.
  static const String _userId = "default_user";

  // Collection reference for the user's chat messages.
  CollectionReference get _chatCollection {
    return _firestore.collection('users').doc(_userId).collection('chats');
  }

  /// Saves a message (user or bot) to Firestore.
  Future<void> saveMessage(ChatMessage message) async {
    try {
      await _chatCollection.add({
        'text': message.text,
        'sender': message.sender.name,
        'timestamp': Timestamp.fromDate(message.timestamp),
      });
    } catch (e) {
      print("Error saving message: $e");
    }
  }

  /// Returns a stream of chat messages ordered by timestamp descending.
  Stream<List<ChatMessage>> getMessagesStream() {
    return _chatCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatMessage(
          text: data['text'] ?? "",
          sender: data['sender'] == 'user' ? MessageSender.user : MessageSender.bot,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}

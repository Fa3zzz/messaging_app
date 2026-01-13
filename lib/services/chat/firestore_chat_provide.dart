import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/services/chat/chat_message.dart';
import 'package:messaging_app/services/chat/chat_provider.dart';

class FirestoreChatProvide implements ChatProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ChatMessage>> chatStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
          .map((doc) => ChatMessage.fromFirebase(doc))
          .toList();
        });
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    await _firestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .add({
      'chatId' : message.chatId,
      'senderId' : message.senderId,
      'text' : message.text,
      'createdAt' : FieldValue.serverTimestamp(),
    });
  }
}
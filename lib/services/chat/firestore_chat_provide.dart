import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
          .map((doc) => ChatMessage.fromFirebase(doc))
          .toList();
        });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('User not logged in');
    }

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'chatId':chatId,
          'senderId':uid,
          'text':text,
          'createdAt':FieldValue.serverTimestamp()
        });
  }
}
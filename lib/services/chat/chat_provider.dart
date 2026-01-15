import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/services/chat/chat_message.dart';

abstract class ChatProvider {
  
  Future<void> sendMessage({
    required String chatId,
    required String text,
  });

  Stream<List<ChatMessage>> chatStream(String chatId);

  Future<String> getOrCreateChatId({
    required String otherUid,
  });

  Future<Map<String, dynamic>?> findUserByExactUsername({required String username});

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream();

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/services/chat/chat_message.dart';
import 'package:messaging_app/services/chat/chat_provider.dart';
import 'package:messaging_app/services/chat/firestore_chat_provider.dart';

class ChatService implements ChatProvider {
  final ChatProvider provider;

  const ChatService(this.provider);

  factory ChatService.firestore() => 
    ChatService(FirestoreChatProvide());

  @override
  Stream<List<ChatMessage>> chatStream(String chatId) {
    return provider.chatStream(chatId);
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) {
    return provider.sendMessage(chatId: chatId, text: text);
  }
  
  @override
  Future<String> getOrCreateChatId({required String otherUid}) {
    return provider.getOrCreateChatId(otherUid: otherUid);
  }
  
  @override
  Future<Map<String, dynamic>?> findUserByExactUsername({required String username}) {
    return provider.findUserByExactUsername(username: username);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream() {
    return provider.chatsStream();
  }
}
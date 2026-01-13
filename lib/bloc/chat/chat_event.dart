import 'package:flutter/foundation.dart';
import 'package:messaging_app/services/chat/chat_message.dart';

@immutable
class ChatEvent {
  const ChatEvent();
}

class ChatStarted extends ChatEvent {
  final String chatId;
  const ChatStarted(this.chatId);
}

class ChatMessageSent extends ChatEvent {
  final ChatMessage message;
  const ChatMessageSent(this.message);
}

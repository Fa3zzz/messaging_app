import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class ChatEvent {
  const ChatEvent();
}

class ChatStarted extends ChatEvent {
  final String chatId;
  const ChatStarted(this.chatId);
}

class ChatMessageSent extends ChatEvent {
  final String chatId;
  final String text;
  const ChatMessageSent({
    required  this.chatId,
    required this.text,
  });
}

class ChatStartRequested extends ChatEvent {
  final String otherUid;
  final String otherUsername;
  const ChatStartRequested({
    required this.otherUid,
    required this.otherUsername,
  });
}

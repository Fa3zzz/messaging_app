import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class ChatMessage {
  final String messageId;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime createdAt;

  const ChatMessage({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromFirebase(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw StateError('Missing data for chat message ${doc.id}');
    }

    return ChatMessage(
      messageId: doc.id, 
      chatId: data['chatId'] as String, 
      senderId: data['senderId'] as String, 
      text: data['text'] as String, 
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );

  }

}
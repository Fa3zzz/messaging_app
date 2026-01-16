import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class FeedCard {
  final String cardId;
  final String authorId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime expiresAt;

  const FeedCard({
    required this.cardId,
    required this.authorId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.expiresAt,
  });

  factory FeedCard.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final cTs = data['createdAt'];
    final createdAt = cTs is Timestamp ? cTs.toDate() : DateTime.now();
    final eTs = data['expiresAt'];
    final expiresAt = eTs is Timestamp ? eTs.toDate() : DateTime.now().add(const Duration(hours: 24));

    return FeedCard(
      cardId: doc.id, 
      authorId: (data["authorId"] ?? '') as String, 
      title: (data["title"] ?? '') as String, 
      content: (data["content"] ?? '') as String, 
      createdAt: createdAt, 
      expiresAt: expiresAt,
    );

  }

}

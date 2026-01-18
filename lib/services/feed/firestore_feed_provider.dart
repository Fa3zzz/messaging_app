import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/services/feed/feed_card.dart';
import 'package:messaging_app/services/feed/feed_provider.dart';

class FirestoreFeedProvider implements FeedProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> createCard({
    required String title, 
    String? content,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('User not logged in');
    }

    final now = Timestamp.now();
    final expiresAt = Timestamp.fromMillisecondsSinceEpoch(
      now.millisecondsSinceEpoch + const Duration(hours: 24).inMilliseconds
    );

    final ref = await _firestore
        .collection('cards')
        .add({
          'authorId': uid,
          'title': title,
          'content': content ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': expiresAt,
        });

    return ref.id;
  }

  @override
  Stream<List<FeedCard>> feedStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return _firestore
        .collection('cards')
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FeedCard.fromFirebase(doc))
              .where((card) => card.authorId != uid)
              .toList();
        });
  }
  
  @override
  Future<void> deleteCard({required String cardId}) {
    return _firestore
            .collection('cards')
            .doc(cardId)
            .delete();
  }
  
@override
Stream<List<FeedCard>> myFeedStream() {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw StateError('User not logged in');

  return _firestore
      .collection('cards')
      .where('authorId', isEqualTo: uid)
      .where('expiresAt', isGreaterThan: Timestamp.now())
      .orderBy('expiresAt')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FeedCard.fromFirebase(doc))
          .toList());

  // return _firestore
  //   .collection('cards')
  //   .where('authorId', isEqualTo: uid)
  //   .orderBy('expiresAt')
  //   .snapshots()
  //   .map((s) => s.docs
  //       .map(FeedCard.fromFirebase)
  //       .where((c) => c.expiresAt.isAfter(DateTime.now()))
  //       .toList());

  }
}
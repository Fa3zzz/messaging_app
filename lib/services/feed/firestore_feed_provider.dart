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

    final ref = await _firestore
        .collection('cards')
        .add({
          'authorId': uid,
          'title': title,
          'content': content ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24))),
        });

    return ref.id;
  }

  @override
  Stream<List<FeedCard>> feedStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return _firestore
        .collection('cards')
        .where('authorId', isNotEqualTo: uid)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt', descending: false)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
          .map((doc) => FeedCard.fromFirebase(doc))
          .toList();
        });
  }
}
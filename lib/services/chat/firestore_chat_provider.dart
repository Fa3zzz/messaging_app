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
    await _firestore.collection('chats').doc(chatId).set({
      'updatedAt' : FieldValue.serverTimestamp(),
      'lastMessage' : text,
    }, SetOptions(merge: true));
  }
  
  @override
  Future<String> getOrCreateChatId({required String otherUid}) async {
    final myUid = FirebaseAuth.instance.currentUser?.uid;
    if(myUid == null) {
      throw StateError('User not logged in');
    }
    if (myUid == otherUid) {
      throw StateError('Canno create chat with yourself');
    }

    final ids = [myUid, otherUid]..sort();
    final chatId = '${ids[0]}_${ids[1]}';

    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatSnap = await chatRef.get();

    if (!chatSnap.exists) {
      await chatRef.set({
        'members' : ids,
        'createdAt' : FieldValue.serverTimestamp(),
        'updatedAt' : FieldValue.serverTimestamp(),
        'lastMessage' : '',
      }, SetOptions(merge: true));
    }

    return chatId;
  }
  
  @override
  Future<Map<String, dynamic>?> findUserByExactUsername({required String username}) async {
    final q = username.trim();
    if(q.isEmpty) {
      return null;
    }

    final snap = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.trim())
        .limit(1)
        .get();
    if(snap.docs.isEmpty) {
      return null;
    }

    final doc = snap.docs.first;
    final data = doc.data();

    return {
      'uid' : doc.id,
      'username' : (data['username'] ?? q) as String,
    };

  }
  
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if(uid == null) {
      throw StateError('User not logged ');
    }
    return _firestore
        .collection('chats')
        .where('memebers', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}
import 'package:messaging_app/services/feed/feed_card.dart';

abstract class FeedProvider {
  Stream<List<FeedCard>> feedStream();

  Stream<List<FeedCard>> myFeedStream();

  Future<String> createCard({
    required String title,
    String? content,
  });

  Future<void> deleteCard({
    required String cardId,
  });
}
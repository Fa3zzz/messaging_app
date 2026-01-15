import 'package:messaging_app/services/feed/feed_card.dart';

abstract class FeedProvider {
  Stream<List<FeedCard>> feedStream();

  Future<String> createCard({
    required String title,
    String? content,
  });
}
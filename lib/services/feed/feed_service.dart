import 'package:messaging_app/services/feed/feed_card.dart';
import 'package:messaging_app/services/feed/feed_provider.dart';
import 'package:messaging_app/services/feed/firestore_feed_provider.dart';

class FeedService implements FeedProvider {

  final FeedProvider provider;

  const FeedService(this.provider);

  factory FeedService.firestore() => FeedService(FirestoreFeedProvider());

  @override
  Future<String> createCard({
    required String title, 
    String? content,
  }) {
    return provider.createCard(title: title, content: content);
  }

  @override
  Stream<List<FeedCard>> feedStream() {
    return provider.feedStream();
  }

}
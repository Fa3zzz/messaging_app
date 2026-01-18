import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/services/feed/feed_service.dart';
import 'package:messaging_app/utilities/dialogs/delete_card_dialog.dart';

class MyCardsView extends StatelessWidget {
  const MyCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final feedService = context.read<FeedService>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('My cards'),
      ),
      body: StreamBuilder(
        stream: feedService.myFeedStream(), 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center (child: Text(snapshot.error.toString()),);
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }
          final cards = snapshot.data!;
          if(cards.isEmpty) {
            return const Center(child: Text('You have no posts to show'),);
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: cards.length,
            itemBuilder: (context, i) {
              final card = cards[i];

              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            card.content,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final shouldDelete = await showDeleteCardDialog(context, 'Are you sure you would like to delete this card?');
                            if (shouldDelete) {
                              await feedService.deleteCard(cardId: card.cardId);
                            } else if (!shouldDelete) {
                              return;
                            }
                          }, 
                          child: const Text('Delete'),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
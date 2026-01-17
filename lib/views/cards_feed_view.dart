import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/cards/card_bloc.dart';
import 'package:messaging_app/bloc/cards/card_event.dart';
import 'package:messaging_app/bloc/chat/chat_bloc.dart';
import 'package:messaging_app/bloc/chat/chat_event.dart';
import 'package:messaging_app/services/chat/chat_provider.dart';
import 'package:messaging_app/services/feed/feed_card.dart';
import 'package:messaging_app/services/feed/feed_service.dart';
import 'package:messaging_app/views/chat_room_view.dart';
import 'package:messaging_app/views/create_cards_sheet.dart';

class CardsFeedView extends StatelessWidget {
  const CardsFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final feedService = context.read<FeedService>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            onPressed: () {
              final bloc = context.read<CardBloc>();
              bloc.add(const CreateCardClear());

              showModalBottomSheet(
                context: context, 
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: bloc,
                  child: const CreateCardsSheet(),
                ),
              );
            }, 
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<List<FeedCard>>(
        stream: feedService.feedStream(), 
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()),);
          }
          if(!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }
          
          final cards = snapshot.data!;
          if(cards.isEmpty) {
            return const Center(child: Text("No cards yet, you're all caught up"),);
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: cards.length,
            itemBuilder: (context, i) {
              final card = cards[i];

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                            final chatProvider = context.read<ChatProvider>();
                            final chatId = await chatProvider
                                                        .getOrCreateChatId(otherUid: card.authorId);
                            if (!context.mounted) return;

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => ChatBloc(chatProvider)..add(ChatStarted(chatId)),
                                  child: ChatRoomView(chatId: chatId, title: chatId),
                                ),
                              )
                            );
                          }, 
                          child: const Text('Reply'),
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
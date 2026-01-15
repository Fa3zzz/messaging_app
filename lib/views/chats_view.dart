import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';
import 'package:messaging_app/bloc/chat/chat_bloc.dart';
import 'package:messaging_app/bloc/chats_list/chats_list_bloc.dart';
import 'package:messaging_app/bloc/chats_list/chats_list_event.dart';
import 'package:messaging_app/bloc/chats_list/chats_list_state.dart';
import 'package:messaging_app/enums/menu_action.dart';
import 'package:messaging_app/services/chat/chat_service.dart';
import 'package:messaging_app/utilities/dialogs/logout_dialog.dart';
import 'package:messaging_app/views/chat_room_view.dart';
import 'package:messaging_app/views/search_user_view.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsListBloc(ChatService.firestore())..add(const ChatsListStarted()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          title: const Text('Chats'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => ChatBloc(ChatService.firestore()),
                      child: const SearchUserView(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    } else if (!shouldLogout) {
                      return;
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: MenuAction.logout,
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: BlocBuilder<ChatsListBloc, ChatsListState>(
          builder: (context, state) {
            if (state is ChatsListInitial) {
              return const Center(child: CircularProgressIndicator(),);
            }
            if (state is ChatsListError) {
              return Center(child: Text(state.message),);
            }
            if (state is ChatsListLoaded) {
              final chats = state.chats;
              if (chats.isEmpty) {
                return const Center(child: Text('No chats yet'),);
              }
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final doc = chats[index];
                  final data = doc.data();
                  final lastMessage = (data['lastMessage'] ?? '') as String;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade500,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(doc.id),
                      subtitle: Text(lastMessage.isEmpty ? 'No messages yet' : lastMessage),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => ChatBloc(ChatService.firestore()),
                              child: ChatRoomView(
                                chatId: doc.id, 
                                title: doc.id,
                              ),
                            ),
                          )
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        )
      ),
    );
  }
}

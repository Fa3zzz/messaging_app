import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';
import 'package:messaging_app/bloc/chat/chat_bloc.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchUserView())
              );
            }, 
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  } else if (!shouldLogout) {
                    return;
                  }
              }
            },itemBuilder: (context) {
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
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade500,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text('Test Chat'),
              subtitle: const Text('chatId = test_chat'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => BlocProvider(
                      create: (_) => ChatBloc(ChatService.firestore()),
                      child: const ChatRoomView(
                        chatId: 'test_chat', 
                        title: 'Test Chat',
                      ),
                    ),
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
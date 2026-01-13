import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';
import 'package:messaging_app/enums/menu_action.dart';
import 'package:messaging_app/utilities/dialogs/logout_dialog.dart';

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
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/chat/chat_bloc.dart';
import 'package:messaging_app/bloc/chat/chat_event.dart';
import 'package:messaging_app/bloc/chat/chat_state.dart';
import 'package:messaging_app/services/chat/chat_service.dart';
import 'package:messaging_app/utilities/dialogs/error_dialog.dart';
import 'package:messaging_app/views/chat_room_view.dart';

class SearchUserView extends StatefulWidget {
  const SearchUserView({super.key});

  @override
  State<SearchUserView> createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {
  late final TextEditingController _controller;

  bool _loading = false;
  Map<String, dynamic>? _foundUser;
  String? _error;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _loading = false;
      _foundUser = null;
      _error = null;
    });
  }

  Future<void> _searchExact() async {
    final q = _controller.text.trim();
    if (q.isEmpty) {
      return;
    }
    setState(() {
      _loading = true;
      _foundUser = null;
      _error = null;
    });

    try {
      final result = await ChatService.firestore().findUserByExactUsername(
        username: q,
      );
      if (result == null) {
        setState(() {
          _loading = false;
          _foundUser = null;
          _error = 'No User Found';
        });

        await showErrorDialog(
          context,
          'User does not exist, please check the useername and try again',
        );
        return;
      }
      setState(() {
        _loading = false;
        _foundUser = result;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _foundUser = null;
        _error = e.toString();
      });
      showErrorDialog(context, e.toString());
    }
  }

  void _startChat() {
    final user = _foundUser;
    if (user == null) return;

    context.read<ChatBloc>().add(
      ChatStartRequested(
        otherUid: user['uid'] as String,
        otherUsername: user['username'] as String,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) async {
        if (state is ChatReady) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => ChatBloc(ChatService.firestore()),
                child: ChatRoomView(
                  chatId: state.chatId, 
                  title: state.title,
                ),
              ),
            )
          );
        } else if (state is ChatError) {
          await showErrorDialog(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(title: const Text('Search Users')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                autocorrect: false,
                autofocus: false,
                controller: _controller,
                onSubmitted: (_) => _searchExact(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Username..',
                  hintStyle: TextStyle(color: Colors.blueGrey.shade900),
                  fillColor: Theme.of(context).colorScheme.surface,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clear,
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              SizedBox(height: 12,),
              SizedBox(
                width: double.infinity,
                child: 
                ElevatedButton(
                  onPressed: query.isEmpty || _loading ? null : _searchExact, 
                  child: _loading 
                      ? const SizedBox(
                        height: 18, 
                        width: 18, 
                        child: CircularProgressIndicator(strokeWidth: 2,), 
                      )
                      : const Text('Search'),
                ),
              ),
              const SizedBox(height: 12,),
              if(_error != null) Text(_error!),
              if(_foundUser != null) 
                ListTile(
                  title: Text(_foundUser!['username'] as String),
                  subtitle: const Text('Exact match'),
                  trailing: ElevatedButton(
                    onPressed: _startChat, 
                    child: const Text('Start chat'),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/chats_list/chats_list_event.dart';
import 'package:messaging_app/bloc/chats_list/chats_list_state.dart';
import 'package:messaging_app/services/chat/chat_provider.dart';

class ChatsListBloc extends Bloc<ChatsListEvent, ChatsListState> {
  final ChatProvider chatProvider;

  ChatsListBloc(this.chatProvider) : super(const ChatsListInitial()) {
    on<ChatsListStarted>(_onStarted);
  }

  Future<void> _onStarted (
    ChatsListStarted event,
    Emitter<ChatsListState> emit,
  ) async {
    await emit.forEach<QuerySnapshot<Map<String, dynamic>>>(
      chatProvider.chatsStream(), 
      onData: (snap) => ChatsListLoaded(snap.docs),
      onError: (error, stackTrace) => ChatsListError(error.toString()),
    );
  }

}
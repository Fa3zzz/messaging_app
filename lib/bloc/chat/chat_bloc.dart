import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/chat/chat_event.dart';
import 'package:messaging_app/bloc/chat/chat_state.dart';
import 'package:messaging_app/services/chat/chat_provider.dart';
import 'dart:async';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatProvider chatProvider;
  StreamSubscription? _subscription;

  ChatBloc(this.chatProvider) : super(const ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<ChatMessageSent>(_onChatMessageSent);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    _subscription ??= chatProvider.chatStream(event.chatId).listen(
      (messages) {
        emit(ChatLoaded(messages));
      },
      onError: (error) {
        emit(ChatError(error.toString()));
      }
    );
  }

  Future<void> _onChatMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatProvider.sendMessage(event.message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/chat/chat_event.dart';
import 'package:messaging_app/bloc/chat/chat_state.dart';
import 'package:messaging_app/services/chat/chat_message.dart';
import 'package:messaging_app/services/chat/chat_provider.dart';
import 'dart:async';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatProvider chatProvider;

  ChatBloc(this.chatProvider) : super(const ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<ChatMessageSent>(_onChatMessageSent);
    on<ChatStartRequested>(_onChatStartRequest);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    await emit.forEach<List<ChatMessage>>(
      chatProvider.chatStream(event.chatId), 
      onData: (messages) => ChatLoaded(messages),
      onError: (error, stackTrace) => ChatError(error.toString()),
    );
  }

  Future<void> _onChatMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatProvider.sendMessage(chatId: event.chatId, text: event.text);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChatStartRequest(
    ChatStartRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final chatId = await chatProvider.getOrCreateChatId(otherUid: event.otherUid);
      emit(ChatReady(chatId: chatId, title: event.otherUsername));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }


}
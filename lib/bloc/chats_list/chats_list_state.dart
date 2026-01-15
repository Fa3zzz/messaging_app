import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ChatsListState extends Equatable {
  const ChatsListState();

  @override
  List<Object?> get props => [];

}

class ChatsListInitial extends ChatsListState {
  const ChatsListInitial();
}

class ChatsListLoaded extends ChatsListState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> chats;
  const ChatsListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];

}

class ChatsListError extends ChatsListState {
  final String message;
  const ChatsListError(this.message);

  @override
  List<Object?> get props => [message];
}
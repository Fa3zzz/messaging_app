import 'package:flutter/foundation.dart';

@immutable
abstract class ChatsListEvent {
  const ChatsListEvent();
}

class ChatsListStarted extends ChatsListEvent {
  const ChatsListStarted();
}
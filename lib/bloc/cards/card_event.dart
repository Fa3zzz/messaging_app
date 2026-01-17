import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object?> get props => [];

}

class CreateCardPressedEvent extends CardEvent {
  final String title;
  final String? content;

  const CreateCardPressedEvent({
    required this.title,
    this.content,
  });

  @override
  List<Object?> get props => [title, content];

}

class CreateCardClear extends CardEvent {
  const CreateCardClear();
}

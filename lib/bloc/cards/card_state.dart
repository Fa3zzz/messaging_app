import 'package:equatable/equatable.dart';

abstract class CardState extends Equatable {
  const CardState();

  @override
  List<Object?> get props => [];

}

class CreateCardIdle extends CardState {
  const CreateCardIdle();
}

class CreateCardDone extends CardState {
  const CreateCardDone();
}

class CreateCardFailed extends CardState {
  final String message;
  CreateCardFailed(this.message);

  @override
  List<Object?> get props => [message];

}
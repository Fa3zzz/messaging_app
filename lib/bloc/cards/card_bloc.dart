import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/cards/card_event.dart';
import 'package:messaging_app/bloc/cards/card_state.dart';
import 'package:messaging_app/services/feed/feed_provider.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final FeedProvider _feedProvider;

  CardBloc({required FeedProvider feedProvider}) : _feedProvider = feedProvider, super (const CreateCardIdle()) {
    on<CreateCardPressedEvent>(_onCreatePressed);
    on<CreateCardClear>((event, emit) => emit(CreateCardIdle()),);
  }

  Future<void> _onCreatePressed(
    CreateCardPressedEvent event,
    Emitter<CardState> emit,
  ) async {
    final title = event.title.trim();
    final content = event.content?.trim();

    if(title.isEmpty) {
      emit(CreateCardFailed('Title cannot be empty'));
      emit(const CreateCardIdle());
      return;
    }

    try {
      await _feedProvider.createCard(
        title: title,
        content: (content == null || content.isEmpty) ? null : content,
      );
      emit(const CreateCardDone());
      emit(const CreateCardIdle());
    } catch (e) {
      emit(CreateCardFailed(e.toString()));
      emit(CreateCardIdle());
    }

  }

}
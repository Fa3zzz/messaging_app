import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/cards/card_bloc.dart';
import 'package:messaging_app/bloc/cards/card_event.dart';
import 'package:messaging_app/bloc/cards/card_state.dart';
import 'package:messaging_app/helpers/loading_screen.dart';
import 'package:messaging_app/utilities/dialogs/error_dialog.dart';

class CreateCardsSheet extends StatefulWidget {
  const CreateCardsSheet({super.key});

  @override
  State<CreateCardsSheet> createState() => _CreateCardsSheetState();
}

class _CreateCardsSheetState extends State<CreateCardsSheet> {
  final _title = TextEditingController();
  final _content = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<CardBloc, CardState>(
      listener: (context, state) async {
        if (state is CreateCardIdle) {
          LoadingScreen().hide();
        }
        if (state is CreateCardDone) {
          LoadingScreen().hide();
          Navigator.pop(context);
        }
        if (state is CreateCardFailed) {
          LoadingScreen().hide();
          await showErrorDialog(context, state.message);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _title,
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(hintText: 'Title...'),
              ),
              SizedBox(height: 16,),
              TextField(
                controller: _content,
                autocorrect: false,
                autofocus: false,
                decoration: InputDecoration(hintText: 'Content...'),
              ),
              SizedBox(height: 16,),
              ElevatedButton(
                onPressed: () {
                  LoadingScreen().show(context: context, text: 'Posting your card..');
                  context.read<CardBloc>().add(CreateCardPressedEvent(
                    title: _title.text,
                    content: _content.text,
                  ));
                }, 
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

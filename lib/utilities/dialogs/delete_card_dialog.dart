import 'package:flutter/material.dart';
import 'package:messaging_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteCardDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<bool>(
    context: context, 
    title: 'Delete card confirmation', 
    content: text, 
    optionsBuilder: () => {
      'Yes': true,
      'No': false,
    },
  ).then(
    (value) => value ?? false,
  );
}
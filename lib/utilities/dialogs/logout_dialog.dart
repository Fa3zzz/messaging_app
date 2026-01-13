import 'package:flutter/material.dart';
import 'package:messaging_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context, 
    title: 'Logout', 
    content: 'Are you sure you would like to logout?', 
    optionsBuilder: () => {
      'Cancel':false,
      'Logout':true,
    },
  ).then(
    (value) => value ?? false,
  );
}
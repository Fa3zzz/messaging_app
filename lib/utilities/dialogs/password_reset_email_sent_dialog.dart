import 'package:flutter/material.dart';
import 'package:messaging_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Password Reset', 
    content: 'Password reset link has been sent to your email, please check you spam normal as well as spam folder', 
    optionsBuilder: () => {
      'Ok':null,
    },
  );
}
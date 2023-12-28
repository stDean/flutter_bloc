import 'package:bloc_state_mgt/05-main-exercise/auth/auth_errors.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<void> showAuthErrorDialog({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {'Ok': true},
  );
}

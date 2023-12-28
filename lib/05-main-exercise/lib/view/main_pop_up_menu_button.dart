import 'package:bloc_state_mgt/05-main-exercise/bloc/app_bloc.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_event.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/dialogs/delete_account_dialog.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuActions { logout, deleteAccount }

class MainPopUpMenuButton extends StatelessWidget {
  MainPopUpMenuButton({super.key});

  final GlobalKey myWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuActions>(
      onSelected: (value) async {
        switch (value) {
          case MenuActions.logout:
            final shouldLogOut = await showLogoutDialog(context);
            if (shouldLogOut) {
              final context = myWidgetKey.currentContext;
              context?.read<AppBloc>().add(const AppEventLogOut());
            }
            break;
          case MenuActions.deleteAccount:
            final shouldDelete = await showDeleteAccountDialog(context);
            if (shouldDelete) {
              final context = myWidgetKey.currentContext;
              context?.read<AppBloc>().add(const AppEventDeleteAccount());
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuActions>(
            value: MenuActions.logout,
            child: Text('Log Out'),
          ),
          const PopupMenuItem<MenuActions>(
            value: MenuActions.deleteAccount,
            child: Text('Delete Account'),
          ),
        ];
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/states/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsState settingsState = Provider.of<SettingsState>(context);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tema do aplicativo",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          RadioListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: "light",
            title: Text(
              "Tema claro",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            groupValue: settingsState.getThemeName(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              settingsState.changeTheme(value);
            },
          ),
          RadioListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: "dark",
            title: Text(
              "Tema escuro",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            groupValue: settingsState.getThemeName(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              settingsState.changeTheme(value);
            },
          ),
          RadioListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: "auto",
            title: Text(
              "Tema do sistema (automático)",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            groupValue: settingsState.getThemeName(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              settingsState.changeTheme(value);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/preferences-conductor.dart';

class PreferencesViewCreator extends StatelessWidget {
  const PreferencesViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorConsumer<PreferencesConductor>(
      builder: (context, conductor) {
        return PreferencesView(conductor: conductor);
      },
    );
  }
}

class PreferencesView extends StatelessWidget {
  final PreferencesConductor conductor;

  const PreferencesView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: conductor.themeMode,
          builder: (context, themeMode, _) {
            return Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) {
                if (value == null) return;
                conductor.setThemeMode(value);
              },
            );
          },
        ),
        const Text('Light'),
        const SizedBox(width: 8),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: conductor.themeMode,
          builder: (context, themeMode, _) {
            return Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) {
                if (value == null) return;
                conductor.setThemeMode(value);
              },
            );
          },
        ),
        const Text('Dark'),
      ],
    );
  }
}

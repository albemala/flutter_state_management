import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/preferences-conductor.dart';
import 'package:flutter_state_management_example/conductors/routing-conductor.dart';
import 'package:flutter_state_management_example/defines/colors.dart';
import 'package:flutter_state_management_example/views/counter-view.dart';
import 'package:flutter_state_management_example/views/menu-view.dart';
import 'package:flutter_state_management_example/views/preferences-view.dart';

class AppViewCreator extends StatelessWidget {
  const AppViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorConsumer<PreferencesConductor>(
      builder: (context, preferencesConductor) {
        return AppView(
          preferencesConductor: preferencesConductor,
        );
      },
    );
  }
}

class AppView extends StatelessWidget {
  final PreferencesConductor preferencesConductor;

  const AppView({
    super.key,
    required this.preferencesConductor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: preferencesConductor.themeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          themeMode: themeMode,
          theme: ThemeData.from(colorScheme: lightColorScheme),
          darkTheme: ThemeData.from(colorScheme: darkColorScheme),
          home: child,
        );
      },
      child: RoutingView(
        routingStream: context.getConductor<RoutingConductor>().routingStream,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter State Architecture'),
          ),
          body: const AppContentView(),
        ),
      ),
    );
  }
}

class AppContentView extends StatelessWidget {
  const AppContentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              PreferencesViewCreator(),
              SizedBox(width: 24),
              CounterViewCreator(),
            ],
          ),
        ),
        Expanded(
          child: MenuViewCreator(),
        ),
      ],
    );
  }
}

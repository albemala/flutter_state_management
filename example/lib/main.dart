import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/counter-conductor.dart';
import 'package:flutter_state_management_example/conductors/local-storage-conductor.dart';
import 'package:flutter_state_management_example/conductors/preferences-conductor.dart';
import 'package:flutter_state_management_example/conductors/routing-conductor.dart';
import 'package:flutter_state_management_example/views/app-view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ConductorCreator(
      create: RoutingConductor.fromContext,
      child: ConductorCreator(
        create: LocalStorageConductor.fromContext,
        child: ConductorCreator(
          create: PreferencesConductor.fromContext,
          child: ConductorCreator(
            create: CounterConductor.fromContext,
            child: AppViewCreator(),
          ),
        ),
      ),
    ),
  );
}

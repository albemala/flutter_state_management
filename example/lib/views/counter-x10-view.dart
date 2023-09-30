import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/counter-conductor.dart';

class CounterX10ViewConductor extends Conductor {
  factory CounterX10ViewConductor.fromContext(BuildContext context) {
    return CounterX10ViewConductor(
      context.getConductor<CounterConductor>(),
    );
  }

  final CounterConductor _counterConductor;

  final counterX10 = ValueNotifier<int>(0);

  CounterX10ViewConductor(
    this._counterConductor,
  ) {
    _init();
  }

  void _init() {
    _updateCounterX10();
    _counterConductor.counter.addListener(_updateCounterX10);
  }

  @override
  void dispose() {
    _counterConductor.counter.removeListener(_updateCounterX10);
    counterX10.dispose();
  }

  void _updateCounterX10() {
    counterX10.value = _counterConductor.counter.value * 10;
  }
}

class CounterX10ViewCreator extends StatelessWidget {
  const CounterX10ViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator<CounterX10ViewConductor>(
      create: CounterX10ViewConductor.fromContext,
      child: ConductorConsumer<CounterX10ViewConductor>(
        builder: (context, conductor) {
          return CounterX10View(conductor: conductor);
        },
      ),
    );
  }
}

class CounterX10View extends StatelessWidget {
  final CounterX10ViewConductor conductor;

  const CounterX10View({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: conductor.counterX10,
      builder: (context, value, _) {
        return Row(
          children: [
            Text('Count x10: $value'),
          ],
        );
      },
    );
  }
}

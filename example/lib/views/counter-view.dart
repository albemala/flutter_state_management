import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/counter-conductor.dart';

class CounterViewCreator extends StatelessWidget {
  const CounterViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorConsumer<CounterConductor>(
      builder: (context, conductor) {
        return CounterView(conductor: conductor);
      },
    );
  }
}

class CounterView extends StatelessWidget {
  final CounterConductor conductor;

  const CounterView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Count: '),
        ValueListenableBuilder<int>(
          valueListenable: conductor.counter,
          builder: (context, value, _) {
            return Text('$value');
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: conductor.increment,
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: conductor.decrement,
        ),
      ],
    );
  }
}

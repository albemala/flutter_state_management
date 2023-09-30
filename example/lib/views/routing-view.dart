import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/routing-conductor.dart';

class RoutesViewCreator extends StatelessWidget {
  const RoutesViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorConsumer<RoutingConductor>(
      builder: (context, conductor) {
        return RoutesView(conductor: conductor);
      },
    );
  }
}

class RoutesView extends StatelessWidget {
  final RoutingConductor conductor;

  const RoutesView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        FilledButton(
          onPressed: () {
            conductor.showSnackBar(
              (context) => SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    const Text('Hello World'),
                  ],
                ),
              ),
            );
          },
          child: const Text('Show SnackBar'),
        ),
        FilledButton(
          onPressed: () {
            conductor.showDialog(
              (context) => AlertDialog(
                title: const Text('Hello World'),
                content: const Text('This is an alert dialog'),
                actions: [
                  TextButton(
                    onPressed: conductor.closeCurrentRoute,
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Dialog'),
        ),
        FilledButton(
          onPressed: () {
            conductor.showBottomSheet(
              (context) => Center(
                child: FilledButton(
                  onPressed: conductor.closeCurrentRoute,
                  child: const Text('Close'),
                ),
              ),
            );
          },
          child: const Text('Show Bottom Sheet'),
        ),
        FilledButton(
          onPressed: () {
            conductor.openRoute(
              (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Route'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () {
                          conductor.showSnackBar(
                            (context) => SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Hello World'),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Text('Show SnackBar'),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: conductor.closeCurrentRoute,
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: const Text('Show Route'),
        ),
      ],
    );
  }
}

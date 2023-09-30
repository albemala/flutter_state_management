import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/local-storage-conductor.dart';

class CounterConductor extends StorableConductor {
  factory CounterConductor.fromContext(BuildContext context) {
    return CounterConductor(
      ConductorStorage(
        context.getConductor<LocalStorageConductor>(),
      ),
    );
  }

  @override
  final ConductorStorage storage;

  final counter = ValueNotifier<int>(0);

  CounterConductor(this.storage) {
    _init();
  }

  Future<void> _init() async {
    await load();
    counter.addListener(_updateAndSave);
  }

  @override
  void dispose() {
    counter.removeListener(_updateAndSave);
    counter.dispose();
  }

  void increment() {
    counter.value++;
  }

  void decrement() {
    counter.value--;
  }

  void _updateAndSave() {
    save();
  }

  @override
  String get storeName => 'counter';

  static const _countKey = 'count';

  @override
  Map<String, dynamic> toMap() {
    return {
      _countKey: counter.value,
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    counter.value = map[_countKey] as int? ?? 0;
  }
}

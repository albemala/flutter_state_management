import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/local-storage-conductor.dart';

class CheckboxesConductor extends StorableConductor {
  factory CheckboxesConductor.fromContext(BuildContext context) {
    return CheckboxesConductor(
      ConductorStorage(
        context.getConductor<LocalStorageConductor>(),
      ),
    );
  }

  @override
  final ConductorStorage storage;

  final checked1 = ValueNotifier(false);
  final checked2 = ValueNotifier(false);
  final checked3 = ValueNotifier(false);
  final checkboxesResult = ValueNotifier('');

  CheckboxesConductor(this.storage) {
    _init();
  }

  Future<void> _init() async {
    await load();
    _updateCheckboxesResult();
    checked1.addListener(_updateAndSave);
    checked2.addListener(_updateAndSave);
    checked3.addListener(_updateAndSave);
  }

  @override
  void dispose() {
    checked1.removeListener(_updateAndSave);
    checked2.removeListener(_updateAndSave);
    checked3.removeListener(_updateAndSave);

    checked1.dispose();
    checked2.dispose();
    checked3.dispose();
    checkboxesResult.dispose();
  }

  void setChecked1(bool value) {
    checked1.value = value;
  }

  void setChecked2(bool value) {
    checked2.value = value;
  }

  void setChecked3(bool value) {
    checked3.value = value;
  }

  void _updateAndSave() {
    _updateCheckboxesResult();
    save();
  }

  void _updateCheckboxesResult() {
    checkboxesResult.value = _getCheckboxesResult();
  }

  String _getCheckboxesResult() {
    final choices = <String>[];
    if (checked1.value) choices.add('1');
    if (checked2.value) choices.add('2');
    if (checked3.value) choices.add('3');

    if (choices.isEmpty) {
      return 'You have checked nothing';
    } else {
      return 'You have checked ${choices.join(', ')}';
    }
  }

  @override
  String get storeName => 'checkboxes';

  @override
  Map<String, dynamic> toMap() {
    return {
      'checked1': checked1.value,
      'checked2': checked2.value,
      'checked3': checked3.value,
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    setChecked1(map['checked1'] as bool? ?? false);
    setChecked2(map['checked2'] as bool? ?? false);
    setChecked3(map['checked3'] as bool? ?? false);
  }
}

class CheckboxesViewCreator extends StatelessWidget {
  const CheckboxesViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: CheckboxesConductor.fromContext,
      child: ConductorConsumer<CheckboxesConductor>(
        builder: (context, conductor) {
          return CheckboxesView(conductor: conductor);
        },
      ),
    );
  }
}

class CheckboxesView extends StatelessWidget {
  final CheckboxesConductor conductor;

  const CheckboxesView({required this.conductor, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: conductor.checked1,
          builder: (context, checked, _) {
            return Checkbox(
              value: conductor.checked1.value,
              onChanged: (value) {
                if (value == null) return;
                conductor.setChecked1(value);
              },
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: conductor.checked2,
          builder: (context, checked, _) {
            return Checkbox(
              value: conductor.checked2.value,
              onChanged: (value) {
                if (value == null) return;
                conductor.setChecked2(value);
              },
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: conductor.checked3,
          builder: (context, checked, _) {
            return Checkbox(
              value: conductor.checked3.value,
              onChanged: (value) {
                if (value == null) return;
                conductor.setChecked3(value);
              },
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: conductor.checkboxesResult,
          builder: (context, checkboxesResult, _) {
            return Text(checkboxesResult);
          },
        ),
      ],
    );
  }
}

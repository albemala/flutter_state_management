import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/local-storage-conductor.dart';

class ColorViewConductor extends StorableConductor {
  factory ColorViewConductor.fromContext(BuildContext context) {
    return ColorViewConductor(
      ConductorStorage(
        context.getConductor<LocalStorageConductor>(),
      ),
    );
  }

  @override
  final ConductorStorage storage;

  final r = ValueNotifier<int>(0);
  final g = ValueNotifier<int>(0);
  final b = ValueNotifier<int>(0);

  final color = ValueNotifier<Color>(
    const Color.fromARGB(255, 0, 0, 0),
  );

  ColorViewConductor(this.storage) {
    _init();
  }

  Future<void> _init() async {
    await load();
    _updateColor();
    r.addListener(_updateAndSave);
    g.addListener(_updateAndSave);
    b.addListener(_updateAndSave);
  }

  @override
  void dispose() {
    r.removeListener(_updateAndSave);
    g.removeListener(_updateAndSave);
    b.removeListener(_updateAndSave);

    r.dispose();
    g.dispose();
    b.dispose();
    color.dispose();
  }

  void setR(int value) {
    r.value = value;
  }

  void setG(int value) {
    g.value = value;
  }

  void setB(int value) {
    b.value = value;
  }

  void _updateAndSave() {
    _updateColor();
    save();
  }

  void _updateColor() {
    color.value = Color.fromARGB(255, r.value, g.value, b.value);
  }

  @override
  String get storeName => 'color';

  @override
  Map<String, dynamic> toMap() {
    return {
      'r': r.value,
      'g': g.value,
      'b': b.value,
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    setR(map['r'] as int? ?? 0);
    setG(map['g'] as int? ?? 0);
    setB(map['b'] as int? ?? 0);
  }
}

class ColorViewCreator extends StatelessWidget {
  const ColorViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: ColorViewConductor.fromContext,
      child: ConductorConsumer<ColorViewConductor>(
        builder: (context, conductor) {
          return ColorView(conductor: conductor);
        },
      ),
    );
  }
}

class ColorView extends StatelessWidget {
  final ColorViewConductor conductor;

  const ColorView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ColorChannelSliderWidget(
          label: 'Red',
          valueNotifier: conductor.r,
          onChanged: conductor.setR,
        ),
        _ColorChannelSliderWidget(
          label: 'Green',
          valueNotifier: conductor.g,
          onChanged: conductor.setG,
        ),
        _ColorChannelSliderWidget(
          label: 'Blue',
          valueNotifier: conductor.b,
          onChanged: conductor.setB,
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: conductor.color,
          builder: (context, colorValue, _) {
            return Container(
              width: 100,
              height: 100,
              color: colorValue,
            );
          },
        ),
      ],
    );
  }
}

class _ColorChannelSliderWidget extends StatelessWidget {
  final String label;
  final ValueNotifier<int> valueNotifier;
  final void Function(int) onChanged;

  const _ColorChannelSliderWidget({
    required this.label,
    required this.valueNotifier,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        return Row(
          children: [
            Text(label),
            const SizedBox(width: 8),
            Text(value.toString()),
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) => onChanged(value.toInt()),
              ),
            ),
          ],
        );
      },
    );
  }
}

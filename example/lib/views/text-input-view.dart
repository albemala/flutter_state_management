import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/local-storage-conductor.dart';

class TextInputViewConductor extends StorableConductor {
  factory TextInputViewConductor.fromContext(BuildContext context) {
    return TextInputViewConductor(
      ConductorStorage(
        context.getConductor<LocalStorageConductor>(),
      ),
    );
  }

  @override
  final ConductorStorage storage;

  final textEditingController = TextEditingController();

  TextInputViewConductor(this.storage) {
    _init();
  }

  Future<void> _init() async {
    await load();
    textEditingController.addListener(_updateAndSave);
  }

  @override
  void dispose() {
    textEditingController.removeListener(_updateAndSave);
    textEditingController.dispose();
  }

  void setText(String value) {
    textEditingController.value = TextEditingValue(
      text: value,
      selection: textEditingController.selection,
    );
  }

  void _updateAndSave() {
    save();
  }

  @override
  String get storeName => 'text-input';

  static const _textKey = 'text';

  @override
  Map<String, dynamic> toMap() {
    return {
      _textKey: textEditingController.text,
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    textEditingController.text = map[_textKey] as String? ?? '';
  }
}

class TextInputViewCreator extends StatelessWidget {
  const TextInputViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator<TextInputViewConductor>(
      create: TextInputViewConductor.fromContext,
      child: ConductorConsumer<TextInputViewConductor>(
        builder: (context, conductor) {
          return TextInputView(conductor: conductor);
        },
      ),
    );
  }
}

class TextInputView extends StatelessWidget {
  final TextInputViewConductor conductor;

  const TextInputView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Text: '),
        Expanded(
          child: TextField(
            controller: conductor.textEditingController,
            onChanged: conductor.setText,
          ),
        ),
      ],
    );
  }
}

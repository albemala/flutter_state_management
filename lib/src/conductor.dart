import 'package:flutter/widgets.dart';

abstract class Conductor {
  void dispose();

  static C of<P extends ConductorProvider<C>, C extends Conductor>(
    BuildContext context,
  ) {
    final provider = context.getInheritedWidgetOfExactType<P>();
    if (provider == null) {
      throw StateError('Provider of type ${P} not found');
    }
    return provider.conductor;
  }
}

abstract class StorableConductor extends Conductor {
  ConductorStorage get storage;
  Future<void> load() async => storage.load(this);
  Future<void> save() async => storage.save(this);

  String get storeName;
  Map<String, dynamic> toMap();
  void fromMap(Map<String, dynamic> map);
}

class ConductorStorage<T extends StorableConductor> {
  final StorageConductor storageConductor;

  ConductorStorage(this.storageConductor);

  Future<void> load(T conductor) async {
    final data = await storageConductor.load(conductor.storeName);
    if (data.isNotEmpty) {
      conductor.fromMap(data);
    }
  }

  Future<void> save(T conductor) async {
    await storageConductor.save(conductor.storeName, conductor.toMap());
  }
}

abstract class StorageConductor {
  Future<Map<String, dynamic>> load(String storeName);
  Future<void> save(String storeName, Map<String, dynamic> map);
}

class ConductorCreator<C extends Conductor> extends StatefulWidget {
  final Widget child;
  final C Function(BuildContext context) create;

  const ConductorCreator({
    super.key,
    required this.child,
    required this.create,
  });

  @override
  State<ConductorCreator<C>> createState() => _ConductorCreatorState<C>();
}

class _ConductorCreatorState<C extends Conductor>
    extends State<ConductorCreator<C>> {
  late C conductor;

  @override
  void initState() {
    super.initState();
    conductor = widget.create(context);
  }

  @override
  Widget build(BuildContext context) {
    return ConductorProvider<C>(
      conductor: conductor,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    conductor.dispose();
    super.dispose();
  }
}

class ConductorProvider<T extends Conductor> extends InheritedWidget {
  final T conductor;

  const ConductorProvider({
    super.key,
    required this.conductor,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant ConductorProvider oldWidget) {
    return oldWidget.conductor != conductor;
  }
}

class ConductorConsumer<T extends Conductor> extends StatelessWidget {
  final Widget Function(BuildContext context, T conductor) builder;

  const ConductorConsumer({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, context.getConductor<T>());
  }
}

extension ConductorProviderExtension on BuildContext {
  C getConductor<C extends Conductor>() {
    return Conductor.of<ConductorProvider<C>, C>(this);
  }
}

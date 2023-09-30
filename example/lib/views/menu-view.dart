import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:flutter_state_management_example/conductors/local-storage-conductor.dart';
import 'package:flutter_state_management_example/views/checkboxes-view.dart';
import 'package:flutter_state_management_example/views/color-view.dart';
import 'package:flutter_state_management_example/views/counter-x10-view.dart';
import 'package:flutter_state_management_example/views/routing-view.dart';
import 'package:flutter_state_management_example/views/text-input-view.dart';

enum MenuItem {
  counterX10,
  checkboxes,
  textInput,
  routing,
  color,
}

String _getMenuItemTitle(MenuItem menuItem) {
  switch (menuItem) {
    case MenuItem.counterX10:
      return 'Counter x10';
    case MenuItem.checkboxes:
      return 'Checkboxes';
    case MenuItem.textInput:
      return 'Text input';
    case MenuItem.routing:
      return 'Routing';
    case MenuItem.color:
      return 'Color';
  }
}

Widget _getMenuItemView(MenuItem menuItem) {
  switch (menuItem) {
    case MenuItem.counterX10:
      return const CounterX10ViewCreator();
    case MenuItem.checkboxes:
      return const CheckboxesViewCreator();
    case MenuItem.textInput:
      return const TextInputViewCreator();
    case MenuItem.routing:
      return const RoutesViewCreator();
    case MenuItem.color:
      return const ColorViewCreator();
  }
}

class MenuViewConductor extends StorableConductor {
  factory MenuViewConductor.fromContext(BuildContext context) {
    return MenuViewConductor(
      ConductorStorage(
        context.getConductor<LocalStorageConductor>(),
      ),
    );
  }

  @override
  final ConductorStorage storage;

  final selectedMenuItem = ValueNotifier<MenuItem>(MenuItem.counterX10);

  MenuViewConductor(this.storage) {
    _init();
  }

  Future<void> _init() async {
    await load();
    selectedMenuItem.addListener(_updateAndSave);
  }

  @override
  void dispose() {
    selectedMenuItem.removeListener(_updateAndSave);
    selectedMenuItem.dispose();
  }

  Widget getCurrentMenuView() {
    return _getMenuItemView(selectedMenuItem.value);
  }

  String getMenuTitle(MenuItem menuItem) {
    return _getMenuItemTitle(menuItem);
  }

  void setSelectedMenuItem(MenuItem menuItem) {
    selectedMenuItem.value = menuItem;
  }

  bool isMenuItemSelected(MenuItem menuItem) {
    return selectedMenuItem.value == menuItem;
  }

  void _updateAndSave() {
    save();
  }

  @override
  String get storeName => 'menu';

  static const _menuItemKey = 'menuItem';

  @override
  Map<String, dynamic> toMap() {
    return {
      _menuItemKey: selectedMenuItem.value.index,
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    final menuItemIndex =
        map[_menuItemKey] as int? ?? MenuItem.counterX10.index;
    selectedMenuItem.value = MenuItem.values[menuItemIndex];
  }
}

class MenuViewCreator extends StatelessWidget {
  const MenuViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: MenuViewConductor.fromContext,
      child: ConductorConsumer<MenuViewConductor>(
        builder: (context, conductor) {
          return MenuView(conductor: conductor);
        },
      ),
    );
  }
}

class MenuView extends StatelessWidget {
  final MenuViewConductor conductor;

  const MenuView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: ValueListenableBuilder<MenuItem>(
            valueListenable: conductor.selectedMenuItem,
            builder: (context, currentView, _) {
              return ListView(
                children: [
                  for (MenuItem view in MenuItem.values)
                    ListTile(
                      selected: conductor.isMenuItemSelected(view),
                      title: Text(conductor.getMenuTitle(view)),
                      onTap: () {
                        conductor.setSelectedMenuItem(view);
                      },
                    ),
                ],
              );
            },
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<MenuItem>(
            valueListenable: conductor.selectedMenuItem,
            builder: (context, currentView, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conductor.getMenuTitle(currentView),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  conductor.getCurrentMenuView(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_3_demo/ui/client/client_screen.dart';
import 'package:material_3_demo/ui/commodity/commodity.dart';
import 'package:material_3_demo/ui/location/location.dart';
import 'package:material_3_demo/ui/search/search_screen.dart';
import 'package:material_3_demo/ui/setting/setting_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

List<NavigationDestination> getAppBarDestinations(BuildContext context) {
  return [
    NavigationDestination(
      tooltip: "",
      icon: const Icon(Icons.widgets_outlined),
      label: AppLocalizations.of(context)?.searchScreenNav ?? "",
      selectedIcon: const Icon(Icons.widgets),
    ),
    NavigationDestination(
      tooltip: "",
      icon: const Icon(Icons.people_alt),
      label: AppLocalizations.of(context)?.clientScreenNav ?? "",
      selectedIcon: const Icon(Icons.people_alt_outlined),
    ),
    NavigationDestination(
      tooltip: "",
      icon: const Icon(Icons.settings),
      label: AppLocalizations.of(context)?.settingScreenNav ?? "",
      selectedIcon: const Icon(Icons.settings_outlined),
    )
  ];
}

const List<Widget> exampleBarDestinations = [
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.explore_outlined),
    label: 'Explore',
    selectedIcon: Icon(Icons.explore),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.pets_outlined),
    label: 'Pets',
    selectedIcon: Icon(Icons.pets),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.account_box_outlined),
    label: 'Account',
    selectedIcon: Icon(Icons.account_box),
  )
];

class NavigationBars extends StatefulWidget {
  final void Function(int)? onSelectItem;
  final int selectedIndex;
  final bool isExampleBar;

  const NavigationBars(
      {super.key,
        this.onSelectItem,
        required this.selectedIndex,
        required this.isExampleBar});

  @override
  State<NavigationBars> createState() => _NavigationBarsState();
}

class _NavigationBarsState extends State<NavigationBars> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        if (!widget.isExampleBar) widget.onSelectItem!(index);
      },
      destinations:
      widget.isExampleBar ? exampleBarDestinations : getAppBarDestinations(context),
    );
  }
}

PersistentTabController controller = PersistentTabController(initialIndex: 0);

//Screens for each nav items.
List<Widget> buildScreens(Key key1, Key key2, Key key3, AadOAuth oauth, Function loginCallback) {
  return [
    SearchScreen(key: key1, showNavBottomBar: false),
    // const LocationScreen(),
    // const CommodityScreen(),
    ClientScreen(key: key2),
    SettingScreen(key: key3, oauth: oauth, loginCallback: loginCallback),
  ];
}

List<PersistentBottomNavBarItem> navBarsItems(BuildContext context) {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.widgets),
      title: (AppLocalizations.of(context)?.searchScreenNav ?? ""),
      activeColorPrimary: Theme.of(context).colorScheme.secondary,
      inactiveColorPrimary: Theme.of(context).colorScheme.primary,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.people_alt),
      title: AppLocalizations.of(context)?.clientScreenNav ?? "",
      activeColorPrimary: Theme.of(context).colorScheme.secondary,
      inactiveColorPrimary: Theme.of(context).colorScheme.primary,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.settings),
      title: AppLocalizations.of(context)?.settingScreenNav ?? "",
      activeColorPrimary: Theme.of(context).colorScheme.secondary,
      inactiveColorPrimary: Theme.of(context).colorScheme.primary,
      // activeColorPrimary: CupertinoColors.activeBlue,
      // inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
}
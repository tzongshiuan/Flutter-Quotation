import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_3_demo/extension.dart';
import 'package:material_3_demo/ui/client/client_screen.dart';
import 'package:material_3_demo/ui/search/search_screen.dart';
import 'package:material_3_demo/ui/setting/setting_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'ui/common/globals.dart' as globals;

import 'navigation.dart';

void main() {
  runApp(const FlutterQuotation());
}

class FlutterQuotation extends StatefulWidget {
  const FlutterQuotation({super.key});

  // This widget is the root of your application.
  @override
  State<FlutterQuotation> createState() => _FlutterQuotationState();
}

// NavigationRail shows if the screen width is greater or equal to
// screenWidthThreshold; otherwise, NavigationBar is used for navigation.
const double narrowScreenWidthThreshold = 450;

const Color m3BaseColor = Color(0xff6750a4);
const List<Color> colorOptions = [
  m3BaseColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink
];
const List<String> colorText = <String>[
  "M3 Baseline",
  "Blue",
  "Teal",
  "Green",
  "Yellow",
  "Orange",
  "Pink",
];

const int searchScreenIndex = 0;
const int clientScreenIndex = 1;
const int settingScreenIndex = 2;

const String tag = "MainScreen";

final navigatorKey = GlobalKey<NavigatorState>();

class _FlutterQuotationState extends State<FlutterQuotation> {
  bool useMaterial3 = true;
  bool useLightMode = true;
  int colorSelected = 0;
  int screenIndex = searchScreenIndex;

  final searchKey = const Key('searchKey');
  final clientKey = const Key('clientKey');
  final settingKey = const Key('settingKey');

  late ThemeData themeData;

  static final Config config = Config(
    tenant: "727fceff-50c9-4204-92cd-380c9888d240",
    clientId: "6ec7cc93-f06a-4914-9327-f5c746a99cba",
    scope: "openid profile offline_access",
    redirectUri: "msauth://com.laidesign.flutter_quotation/kZZ0RVmcGZo2Vva4Cw482y7ftxc=",
    navigatorKey: navigatorKey,
  );
  final AadOAuth oauth = AadOAuth(config);

  @override
  initState() {
    super.initState();
    themeData = updateThemes(colorSelected, useMaterial3, useLightMode);

    // It is possible to register callbacks in order to handle return values
    // from asynchronous calls to the plugin
    // AzureB2C.registerCallback(B2COperationSource.INIT, (result) async {
    //   debugPrint("AzureB2C.registerCallback, reason: ${result.reason}");
    //
    //   if (result.reason == B2COperationState.SUCCESS) {
    //     _configuration = await AzureB2C.getConfiguration();
    //   }
    // });
    //
    // // Important: Remeber to handle redirect states (if you want to support
    // // the web platform with redirect method) and init the AzureB2C plugin
    // // before the material app starts.
    // AzureB2C.handleRedirectFuture().then((_) => AzureB2C.init("auth_config_b2c"));
  }

  ThemeData updateThemes(int colorIndex, bool useMaterial3, bool useLightMode) {
    return ThemeData(
        colorSchemeSeed: colorOptions[colorSelected],
        useMaterial3: useMaterial3,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void handleBrightnessChange() {
    setState(() {
      useLightMode = !useLightMode;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = value;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
  }

  // Widget createScreenFor(int screenIndex, bool showNavBarExample) {
  //   switch (screenIndex) {
  //     case searchScreenIndex:
  //       return SearchScreen(showNavBottomBar: showNavBarExample);
  //     case clientScreenIndex:
  //       return const ClientScreen();
  //     case settingScreenIndex:
  //       return SettingScreen(oauth: oauth);
  //     default:
  //       return SearchScreen(showNavBottomBar: showNavBarExample);
  //   }
  // }

  PreferredSizeWidget createAppBar(BuildContext context) {
    return AppBar(
      title: Text(
          AppLocalizations.of(context)?.appTitle ?? ""
      ), //useMaterial3 ? const Text("Material 3") : const Text("Material 2"),
      actions: [
        IconButton(
          icon: useLightMode
              ? const Icon(Icons.wb_sunny_outlined)
              : const Icon(Icons.wb_sunny),
          onPressed: handleBrightnessChange,
          tooltip: "Toggle brightness",
        ),
        IconButton(
          icon: useMaterial3
              ? const Icon(Icons.filter_3)
              : const Icon(Icons.filter_2),
          onPressed: handleMaterialVersionChange,
          tooltip: "Switch to Material ${useMaterial3 ? 2 : 3}",
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) {
            return List.generate(colorOptions.length, (index) {
              return PopupMenuItem(
                  value: index,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          index == colorSelected
                              ? Icons.color_lens
                              : Icons.color_lens_outlined,
                          color: colorOptions[index],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(colorText[index]))
                    ],
                  ));
            });
          },
          onSelected: handleColorSelect,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return myMaterialApp(context);
  }

  Widget myMaterialApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Flutter Quotation',
      themeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: themeData,
      navigatorKey: navigatorKey,
      home: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          appBar: createAppBar(context),
          body: Center(
            child: PersistentTabView(
              context,
              controller: controller,
              screens: buildScreens(searchKey, clientKey, settingKey, oauth, _loginCallback),
              items: navBarsItems(context),
              confineInSafeArea: true,
              backgroundColor: Colors.white, // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true, // Default is true.
              hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
            ),
          ),
          // bottomNavigationBar: NavigationBars(
          //   onSelectItem: handleScreenChanged,
          //   selectedIndex: screenIndex,
          //   isExampleBar: false,
          // ),
        );
      }),
    );
  }

  void _loginCallback(String text) {
    setState(() {
      debugPrint("$tag _loginCallback: $text");
      globals.azureAccessToken = text;
    });
  }
}
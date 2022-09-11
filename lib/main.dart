import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_3_demo/extension.dart';
import 'package:material_3_demo/ui/client/client_screen.dart';
import 'package:material_3_demo/ui/search/search_screen.dart';
import 'package:material_3_demo/ui/setting/setting_screen.dart';

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

class _FlutterQuotationState extends State<FlutterQuotation> {
  bool useMaterial3 = true;
  bool useLightMode = true;
  int colorSelected = 0;
  int screenIndex = searchScreenIndex;

  late ThemeData themeData;

  @override
  initState() {
    super.initState();
    themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
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

  Widget createScreenFor(int screenIndex, bool showNavBarExample) {
    switch (screenIndex) {
      case searchScreenIndex:
        return SearchScreen(showNavBottomBar: showNavBarExample);
      case clientScreenIndex:
        return const ClientScreen();
      case settingScreenIndex:
        return const SettingScreen();
      default:
        return SearchScreen(showNavBottomBar: showNavBarExample);
    }
  }

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
      home: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          appBar: createAppBar(context),
          body: Row(children: <Widget>[
            createScreenFor(screenIndex, false),
          ]),
          bottomNavigationBar: NavigationBars(
            onSelectItem: handleScreenChanged,
            selectedIndex: screenIndex,
            isExampleBar: false,
          ),
        );
      }),
    );
  }
}
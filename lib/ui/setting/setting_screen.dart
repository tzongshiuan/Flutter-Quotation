import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_3_demo/ui/common/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/globals.dart' as globals;
import '../common/globals.dart';

const String tag = "SettingScreen";

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key, required this.oauth, required this.loginCallback});

  final AadOAuth oauth;
  Function loginCallback;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final multiplierController = TextEditingController();
  final usdPriceController = TextEditingController();
  final silverPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readSetting();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    var oauth = widget.oauth;

    multiplierController.text = settingMultiplier;
    usdPriceController.text = settingUsdPrice;
    silverPriceController.text = settingSilverPrice;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    AppLocalizations.of(context)?.settingPageTitle ?? "",
                    style: textTheme.headlineMedium,
                    textAlign: TextAlign.center
                ),
                largeColDivider,
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onEditingComplete: _saveSetting,
                    controller: multiplierController,
                    style: textTheme.headlineSmall,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.settingCustomMultiLabel ?? "",
                      labelStyle: textTheme.headlineSmall?.copyWith(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onEditingComplete: _saveSetting,
                    controller: usdPriceController,
                    style: textTheme.headlineSmall,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.settingUsdPriceLabel ?? "",
                      labelStyle: textTheme.headlineSmall?.copyWith(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onEditingComplete: _saveSetting,
                    controller: silverPriceController,
                    style: textTheme.headlineSmall,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.settingSilverPriceLabel ?? "",
                      labelStyle: textTheme.headlineSmall?.copyWith(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomButton(context, textTheme),
    );
  }

  Widget _bottomButton(BuildContext context, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          // ignore: prefer_const_constructors
          minimumSize: Size.fromHeight(50),
          // Foreground color
          // ignore: deprecated_member_use
          onPrimary: Theme
              .of(context)
              .colorScheme
              .onPrimary,
          // Background color
          // ignore: deprecated_member_use
          primary: Theme
              .of(context)
              .colorScheme
              .primary,
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
        onPressed: _onLoginBtnClick(context),
        label: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
              left: 0.0, top: 10.0, right: 16.0, bottom: 10.0),
          child: Text(
            AppLocalizations
                .of(context)
                ?.settingLoginText ?? "",
            style: textTheme.titleLarge!.copyWith(
                color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ),
        icon: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.only(left: 0.0),
          child: const Icon(Icons.login),
        ),
      ),
    );
  }

  void Function() _onLoginBtnClick(BuildContext context) {
    return () {
      debugPrint("$tag _onLoginBtnClick()");

      if (globals.azureAccessToken.isNotEmpty) {
        widget.loginCallback("");
      } else {
        widget.loginCallback("GGGGGGGGGGGGGGGGGGGG");
      }
    };
  }

  Future<void> _readSetting() async {
    debugPrint("$tag _readSetting()");

    final SharedPreferences prefs = await _prefs;
    setState(() {
      settingMultiplier = prefs.getString('multiplier') ?? "1.0";
      settingUsdPrice = prefs.getString('usdPrice') ?? "30.0";
      settingSilverPrice = prefs.getString('silverPrice') ?? "30.0";
    });
  }

  Future<void> _saveSetting() async {
    debugPrint("$tag _saveSetting()");

    final SharedPreferences prefs = await _prefs;
    prefs.setString('multiplier', multiplierController.text);
    prefs.setString('usdPrice', usdPriceController.text);
    prefs.setString('silverPrice', silverPriceController.text);

    settingMultiplier = multiplierController.text;
    settingUsdPrice = usdPriceController.text;
    settingSilverPrice = silverPriceController.text;

    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _test(BuildContext context) {
    var oauth = widget.oauth;

    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      // you can just perform calls to the AzureB2C plugin to
                      // handle the B2C protocol (e.g. acquire, refresh tokens
                      // or sign out).
                      // var data = await AzureB2C.policyTriggerInteractive(
                      //     configuration!.defaultAuthority.policyName,
                      //     configuration!.defaultScopes!,
                      //     null
                      // );
                      // setState(() {
                      //   _retData = data;
                      // });

                      try {
                        await oauth.login();
                        var accessToken = await oauth.getAccessToken();
                        debugPrint('Logged in successfully, your access token: $accessToken');
                      } catch (e) {
                        debugPrint('$e');
                        // showError(e);
                      }
                    },
                    child: Text("LogIn")),
                TextButton(
                    onPressed: () async {
                      // var subjects = await AzureB2C.getSubjects();
                      // var info = await AzureB2C.getUserInfo(subjects![0]);
                      // setState(() {
                      //   _subjects = subjects;
                      //   _retData = json.encode(info);
                      // });
                    },
                    child: Text("UserInfo")),
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      // var token = await AzureB2C.getAccessToken(_subjects![0]);
                      // setState(() {
                      //   _retData = json.encode(token);
                      // });
                    },
                    child: Text("AccessToken")),
                TextButton(
                    onPressed: () async {
                      // var data = await AzureB2C.policyTriggerSilently(
                      //   _subjects![0],
                      //   configuration!.defaultAuthority.policyName,
                      //   configuration!.defaultScopes!,
                      // );
                      // setState(() {
                      //   _retData = data;
                      // });
                    },
                    child: Text("Refresh")),
                TextButton(
                    onPressed: () async {
                      await oauth.logout();
                      // var data = await AzureB2C.signOut(_subjects![0]);
                      // setState(() {
                      //   _retData = data;
                      // });
                    },
                    child: Text("LogOut")),
              ],
            ),
            Text("123")
          ],
        )
    );
  }
}
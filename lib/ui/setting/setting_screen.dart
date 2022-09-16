import 'dart:convert';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';

const String tag = "SettingScreen";

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, required this.oauth});

  final AadOAuth oauth;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  String _retData = "";
  List<String>? _subjects;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    var oauth = widget.oauth;

    return Scaffold(
      body: Container(
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
              Text(_retData)
            ],
          )
      ),
    );
  }
}
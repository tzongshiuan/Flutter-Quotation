import 'package:flutter/material.dart';

import '../common/common_util.dart';
import '../common/globals.dart' as globals;

const String tag = "ClientScreen";

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    if (globals.azureAccessToken.isNotEmpty) {
      return Expanded(
          child: Text("BBB")
      );
    } else {
      return needLoginUI(context, textTheme);
    }
  }
}
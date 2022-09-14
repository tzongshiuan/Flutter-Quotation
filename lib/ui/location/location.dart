import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../common/common_util.dart';

const String tag = "LocationScreen";

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Expanded(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Text("AAA"),
            ],
          ),
        )
    );
  }
}
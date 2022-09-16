import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const microColDivider = SizedBox(height: 1);
const smallColDivider = SizedBox(height: 10);
const mediumColDivider = SizedBox(height: 20);
const largeColDivider = SizedBox(height: 30);

const microRowDivider = SizedBox(width: 1);
const smallRowDivider = SizedBox(width: 10);
const mediumRowDivider = SizedBox(width: 20);
const largeRowDivider = SizedBox(width: 30);

const imageAssetPath = "assets/images";
var imgPlaceholder = const AssetImage("$imageAssetPath/img_loading.gif");
var imgErrorDefault = Image.asset("$imageAssetPath/ic_commodity_default.jpg");

void showToast(BuildContext context, String text) {
  final scaffold = ScaffoldMessenger.of(context);
  final snackBar = SnackBar(
    content: Text(
      text,
      style: TextStyle(
          fontSize: 22,
          color: Theme.of(context).colorScheme.surface
      ),
    ),
    action: SnackBarAction(
      textColor: Theme.of(context).colorScheme.surface,
      label: 'Close',
      onPressed: scaffold.hideCurrentSnackBar,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

TextStyle getCommodityLabelTextStyle(BuildContext context, TextStyle style) {
  return style.copyWith(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.bold
  );
}

Widget needLoginUI(BuildContext context, TextTheme textTheme) {
  return Container(
    padding: const EdgeInsets.all(20.0),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning,
          color: Colors.orange,
          size: 70.0,
        ),
        Text(
            AppLocalizations.of(context)?.settingNeedLogin ?? "",
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center
        ),
      ],
    ),
  );
}
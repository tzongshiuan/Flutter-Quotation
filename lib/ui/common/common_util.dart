import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const smallColDivider = SizedBox(height: 10);
const mediumColDivider = SizedBox(height: 20);
const largeColDivider = SizedBox(height: 30);

const smallRowDivider = SizedBox(width: 10);
const mediumRowDivider = SizedBox(width: 20);
const largeRowDivider = SizedBox(width: 30);

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
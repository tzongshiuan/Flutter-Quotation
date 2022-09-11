import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.showNavBottomBar});

  final bool showNavBottomBar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
          children: [
            Text("AAA"),
          ],
        )
    );
  }
}
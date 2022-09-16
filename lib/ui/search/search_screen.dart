import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_3_demo/ui/commodity/commodity.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../common/common_util.dart';
import '../location/location.dart';

const String tag = "SearchScreen";

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.showNavBottomBar});

  final bool showNavBottomBar;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Expanded(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  AppLocalizations.of(context)?.searchScanQrCodeHintText ?? "",
                  style: textTheme.headlineSmall!,
                  textAlign: TextAlign.center
              ),
              smallColDivider,
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // ignore: prefer_const_constructors
                  minimumSize: Size.fromHeight(70),
                  // Foreground color
                  // ignore: deprecated_member_use
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  // Background color
                  // ignore: deprecated_member_use
                  primary: Theme.of(context).colorScheme.primary,
                ).copyWith(
                    elevation: ButtonStyleButton.allOrNull(0.0),
                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //     RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(18.0),
                    //         side: BorderSide(color: Colors.red)
                    //     )
                    // )
                ),
                onPressed: onSearchLocationBtnClick(context),
                label: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 16.0, bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context)?.searchScanQrCodeBtnText ?? "",
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
                  child: const Icon(Icons.qr_code),
                ),
              ),
              smallColDivider,
              Text(
                  AppLocalizations.of(context)?.searchScanQrCodeHintText2 ?? "",
                  style: textTheme.headlineSmall!,
                  textAlign: TextAlign.center
              ),
              smallColDivider,
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // ignore: prefer_const_constructors
                  minimumSize: Size.fromHeight(70),
                  // Foreground color
                  // ignore: deprecated_member_use
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  // Background color
                  // ignore: deprecated_member_use
                  primary: Theme.of(context).colorScheme.primary,
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                onPressed: onSearchCommodityBtnClick(context),
                label: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 16.0, bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context)?.locationRescanBtnText ?? "",
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
                  child: const Icon(Icons.qr_code),
                ),
              )
            ],
          ),
        )
    );
  }

  void Function() onSearchLocationBtnClick(BuildContext context) {
    return () {
      debugPrint("$tag onSearchLocationBtnClick()");
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const LocationScreen(),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    };
  }

  void Function() onSearchCommodityBtnClick(BuildContext context) {
    return () {
      debugPrint("$tag onSearchCommodityBtnClick()");
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const CommodityScreen(),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    };
  }
}
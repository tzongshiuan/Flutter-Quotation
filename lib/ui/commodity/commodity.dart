import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../common/common_util.dart';

const String tag = "CommodityScreen";

class CommodityScreen extends StatefulWidget {
  const CommodityScreen({super.key});

  @override
  State<CommodityScreen> createState() => _CommodityScreenState();
}

class _CommodityScreenState extends State<CommodityScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey
    = GlobalKey<RefreshIndicatorState>();
  String? result;
  QRViewController? controller;
  bool isAttributeVisible = true;

  @override
  initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Future<void> _handleRefresh() async {
    debugPrint("$tag _handleRefresh()");
    // _fetchCommodityList();
    await Future.delayed(const Duration(seconds: 2), () {
      // setState(() {
        // entityList.clear();
        // entityList = List.generate(
        //     10,
        //         (index) =>
        //     new ItemEntity("下拉刷新後--item $index", Icons.accessibility));
        // return null;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      body: (result != null)
            ? _onScanFinishUI(context, textTheme)
            : _scanningUI(textTheme),
      bottomNavigationBar: (result != null)
          ? _searchAgainBtn(context, textTheme)
          : smallColDivider,
      floatingActionButton: (result != null)
        ? _floatingVisibleBtn(context, textTheme)
        : null,
    );
  }

  Widget _scanningUI(TextTheme textTheme) {
    final pnTextController = TextEditingController();

    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: pnTextController,
                style: textTheme.headlineSmall,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _onPnSendBtnClick(context, pnTextController.text),
                    icon: const Icon(Icons.send),
                  ),
                  labelText: AppLocalizations.of(context)?.commodityCustomCodeHint ?? "",
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
          ),
        )
      ],
    );
  }

  Widget _onScanFinishUI(BuildContext context, TextTheme textTheme) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      // color: Colors.white,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      // strokeWidth: 4.0,
      onRefresh: _handleRefresh,
      notificationPredicate: (ScrollNotification notification) {
        return notification.depth == 1;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _commodityList(context, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _commodityList(BuildContext context, TextTheme textTheme) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[100],
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
            child: Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.6,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(width: 1.0, color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: FadeInImage(
                                  placeholder: imgPlaceholder,
                                  image: NetworkImage('https://picsum.photos/250?image=9000'),
                                  imageErrorBuilder: (context, error, stack) {
                                    return imgErrorDefault;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0, bottom: 0.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.lightGreen,
                              size: 35.0,
                            ),
                            onPressed: _onEditImageBtnClick(context, textTheme),
                          ),
                        ),
                      ],
                    ),
                    _commodityAttributes(context, textTheme)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _commodityAttributes(BuildContext context, TextTheme textTheme) {
    var pn = "${AppLocalizations.of(context)?.commodityAttributeProductNumber ?? ""}: ";
    var priceNote = "${AppLocalizations.of(context)?.commodityAttributePriceNote ?? ""}: ";

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getAttributeText(pn, "123", context, textTheme),
            _getAttributeText(priceNote, "123", context, textTheme),

            _commodityExtAttributes(context, textTheme)
          ],
        ),
      ),
    );
  }

  Widget _commodityExtAttributes(BuildContext context, TextTheme textTheme) {
    var stonePriceWarn = "${AppLocalizations.of(context)?.commodityAttributeStonePriceWarning ?? ""}: ";

    if (isAttributeVisible) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getAttributeText(stonePriceWarn, "123", context, textTheme),
        ],
      );
    } else {
      return microColDivider;
    }
  }

  Widget _getAttributeText(String label, String attr, BuildContext context, TextTheme textTheme) {
    return RichText(
      text: TextSpan(
          text: label,
          style: getCommodityLabelTextStyle(context, textTheme.titleLarge!),
          children: [
            TextSpan(
                text: attr,
                style: textTheme.titleLarge!
            )
          ]
      ),
    );
  }

  Widget _searchAgainBtn(BuildContext context, TextTheme textTheme) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(15.0),
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          // ignore: prefer_const_constructorsA
          minimumSize: const Size.fromHeight(50),
          // Foreground color
          // ignore: deprecated_member_use
          onPrimary: Theme.of(context).colorScheme.onPrimary,
          // Background color
          // ignore: deprecated_member_use
          primary: Theme.of(context).colorScheme.primary,
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
        onPressed: _onRescanBtnClick(context),
        label: Container(
          width: 200,
          padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 16.0, bottom: 10.0),
          child: Text(
            AppLocalizations.of(context)?.commodityRescanBtnText ?? "",
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
    );
  }

  Widget _floatingVisibleBtn(BuildContext context, TextTheme textTheme) {
    Icon icon;
    if (isAttributeVisible) {
      icon = const Icon(Icons.visibility_off);
    } else {
      icon = const Icon(Icons.visibility);
    }

    return FloatingActionButton(
      onPressed: () {
        setState(() {
          isAttributeVisible = !isAttributeVisible;
        });
      },
      backgroundColor: Colors.green[200],
      child: icon,
    );
  }

  void Function() _onPnSendBtnClick(BuildContext context, String productNumber) {
    return () {
      debugPrint("$tag _onPnSendBtnClick()");
      setState(() {
        result = productNumber;
      });
    };
  }
  void Function() _onEditImageBtnClick(BuildContext context, TextTheme textTheme) {
    return () {
      debugPrint("$tag _onEditImageBtnClick()");
      showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.commodityDialogPhotoSelectTitle ?? "",
            style: textTheme.titleLarge!
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: _goCameraPage(context),
                  child: Text(
                      AppLocalizations.of(context)?.gCamera ?? "",
                      style: textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary)
                  )
              ),
              TextButton(
                  onPressed: _goSelectPhotoPage(context),
                  child: Text(
                      AppLocalizations.of(context)?.gPhotoAlbum ?? "",
                      style: textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary)
                  )
              )
            ],
          ),
          // actions: <Widget>[
          //   TextButton(
          //     onPressed: () => {
          //       Navigator.pop(context, 'Cancel')
          //     },
          //     child: Text(
          //       'Cancel',
          //       style: textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary)
          //     ),
          //   ),
          //   TextButton(
          //     onPressed: () => {
          //       Navigator.pop(context, 'OK')
          //     },
          //     child: Text(
          //       'OK',
          //       style: textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary)
          //     ),
          //   ),
          // ],
        )
      );
    };
  }

  void Function() _onRescanBtnClick(BuildContext context) {
    return () {
      debugPrint("$tag onRescanBtnClick()");
      controller?.resumeCamera();
      setState(() {
        result = null;
      });
    };
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
        controller.pauseCamera();
      });
    });
    controller.resumeCamera();
  }

  void Function() _goCameraPage(BuildContext context) {
    return () {
      debugPrint("$tag _goCameraPage()");
      showToast(context, "Camera");

      Navigator.pop(context, '_goCameraPage');
      // pushNewScreen(
      //   context,
      //   screen: const LocationScreen(),
      //   withNavBar: true, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
    };
  }

  void Function() _goSelectPhotoPage(BuildContext context) {
    return () {
      debugPrint("$tag _goSelectPhotoPage()");
      showToast(context, "Select Photo");

      Navigator.pop(context, '_goSelectPhotoPage');
      // pushNewScreen(
      //   context,
      //   screen: const LocationScreen(),
      //   withNavBar: true, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
    };
  }

  @override
  void dispose() {
    controller?.dispose();
    result = null;
    super.dispose();
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../common/common_util.dart';

const String tag = "LocationScreen";

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? controller;

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      body: Column(
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
              child: (result != null)
                  ? _onScanFinishUI(context, textTheme)
                  : _scanningUI(textTheme),
            ),
          )
        ],
      ),
    );
  }

  Widget _scanningUI(TextTheme textTheme) {
    return Text(
        AppLocalizations.of(context)?.locationWaitResultText ?? "",
        style: textTheme.headlineSmall,
        textAlign: TextAlign.center
    );
  }

  Widget _onScanFinishUI(BuildContext context, TextTheme textTheme) {
    final locationTextController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(20.0),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  "${AppLocalizations.of(context)?.locationResultLabel}${result?.code}",
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center
              ),
              largeColDivider,
              TextField(
                controller: locationTextController,
                style: textTheme.headlineSmall,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _onLocationSendBtnClick(context),
                    icon: const Icon(Icons.send),
                  ),
                  labelText: AppLocalizations.of(context)?.locationEditLocationHint ?? "",
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
              largeColDivider,
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // ignore: prefer_const_constructors
                  minimumSize: Size.fromHeight(50),
                  // Foreground color
                  // ignore: deprecated_member_use
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  // Background color
                  // ignore: deprecated_member_use
                  primary: Theme.of(context).colorScheme.primary,
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                onPressed: _onRescanBtnClick(context),
                label: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 16.0, bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context)?.searchScanQrCodeBtnText2 ?? "",
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
        ),
      ),
    );
  }

  void Function() _onLocationSendBtnClick(BuildContext context) {
    return () {
      debugPrint("$tag onLocationSendBtnClick()");
      showToast(context, "Send message");
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
        result = scanData;
        controller.pauseCamera();
      });
    });
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    result = null;
    super.dispose();
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/snackbar.dart';
import 'package:vstock/controller/barcodeController.dart';
import 'package:vstock/controller/registrationController.dart';
import 'package:vstock/model/barcodeScannerModel.dart';

class ScanBarcode extends StatefulWidget {
  String type;

  ScanBarcode({required this.type});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  SnackbarCommon snackbr = SnackbarCommon();
  DateTime now = DateTime.now();

  String? date;
  List<Data>? result;
  QRViewController? controller;
  String _barcodeScanned = "";
  bool _scanCode = false;
  int count = 0;
  int countInt = 1;
  TextEditingController _textController = TextEditingController();
  TextEditingController _barcodeText = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void initState() {
    date = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorThemeComponent.color4,
      ),
      body: Transform.translate(
        offset: Offset(0.0, -0.4 * MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Barcode  : ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (widget.type == "Free Scan with quantity" ||
                          widget.type == "API Scan with quantity")
                        Container(
                          height: size.height * 0.05,
                          width: size.width * 0.1,
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                            controller: _barcodeText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            // decoration: In,
                          ),
                        ),
                      if (widget.type == "Free Scan" ||
                          widget.type == "API Scan")
                        Container(
                          //  height: size.height*0.057,
                          child: Center(
                              child: Text(
                            _barcodeScanned == null
                                ? "scan a code"
                                : _barcodeScanned.toString(),
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          )),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  if (widget.type == "Free Scan" || widget.type == "API Scan")
                    Container(
                      height: size.height * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Color(0xFF424242),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          count.toString(),
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                    ),
                  if (widget.type == "Free Scan with quantity" ||
                      widget.type == "API Scan with quantity")
                    Column(
                      children: [
                        Container(
                          width: size.width * 0.2,
                          height: size.height * 0.06,
                          child: Center(
                            child: TextFormField(
                              inputFormatters: [
                                // only accept letters from 0 to 9
                                FilteringTextInputFormatter(RegExp(r'[0-9]'),
                                    allow: true)
                                // Using for Text Only ==>    (RegExp(r'[a-zA-Z]'))
                              ],
                              keyboardType: TextInputType.number,
                              controller: _textController,
                              onFieldSubmitted: (val) {
                                _barcodeScanned = _barcodeScanned;
                                print("value----${val} --- ${_barcodeScanned}");
                              },
                              decoration: InputDecoration(hintText: "1"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: ColorThemeComponent.regButtonColor,
                            ),
                            onPressed: () {
                              if (_textController.text.isEmpty ||
                                  _textController.text == null) {
                                print(" empty");
                                countInt = 1;
                                print("count int--${countInt}");
                              }

                              if (_textController.text.isNotEmpty ||
                                  _textController.text != null) {
                                print("not empty");
                                countInt = int.tryParse(
                                        _textController.text.toString()) ??
                                    1;
                                // int.parse(_textController.text.toString());
                              }

                              if (_barcodeText.text.isEmpty) {
                                print("text empty");
                                snackbr.showSnackbar(
                                    context, "Invalid Barcode!!!");
                              }
                              print(
                                  "save button------${_barcodeText.text}, ${date}");

                              if (_barcodeText.text.isNotEmpty) {

                                if (widget.type == "Free Scan with quantity") {
                                  // Provider.of<BarcodeController>(context,
                                  //         listen: false)
                                  //     .insertintoTableScanlog(
                                  //         _barcodeText.text,

                                  //         countInt,
                                  //         2,
                                  //         "Free Scan with quantity");
                                }
                                if (widget.type == "API Scan with quantity") {
                                  if (_barcodeScanned != null ||
                                      _barcodeScanned.isNotEmpty) {
                                    // Provider.of<RegistrationController>(context,
                                    //         listen: false)
                                    //     .postData(
                                    //         _barcodeText.text,
                                    //         formattedDate,
                                    //         context,
                                    //         countInt,
                                    //         4,
                                    //         "API Scan with quantity");
                                  }
                                }
                              }

                              _textController.clear();
                              _barcodeText.clear();
                              // _barcodeScanned = " hihi";

                              // setState(() {

                              // });
                              controller!.resumeCamera();
                            },
                            child: Text(
                              "save",
                              style: TextStyle(fontSize: 17),
                            ))
                      ],
                    ),

                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  // GestureDetector(
                  //   onLongPress: () {
                  //     print("pressed");
                  //     _cameraUpdate(true);
                  //   },
                  //   onLongPressEnd: (_) {
                  //     print("long press cancel");
                  //     _cameraUpdate(false);
                  //   },
                  //   child: Container(
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  //       onPressed: () {},
                  //       child: Icon(
                  //         Icons.camera,
                  //         size: 50,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // if (_scanCode) {/
      if (_barcodeScanned == scanData.code) {
        Future.delayed(Duration(seconds: 3), () async {
          _barcodeScanned = "";
        });
      } else {
        setState(() {
          _barcodeScanned = scanData.code!;
          _barcodeText.text = _barcodeScanned;
          int c = int.parse(
              Provider.of<BarcodeController>(context, listen: false).count);
          count = c + 1;
          print("count====$count");
        });
        await FlutterBeep.beep();
        controller.pauseCamera();
        now = DateTime.now();
        print(DateTime.now());
        if (_barcodeScanned != null && _barcodeScanned.isNotEmpty) {
          print("barcode----------------${_barcodeScanned}");

          // await BarcodeDB.instance.barcodeTimeStamtttp(_barcodeScanned, formattedDate, count);
          //  await BarcodeScanlogDB.instance.barcodeTimeStamp(_barcodeScanned, formattedDate, count,1);
          if (widget.type == "Free Scan") {
            Provider.of<BarcodeController>(context, listen: false)
                .insertintoTableScanlog(_barcodeText.text, date, 1,
                    countInt, 1, "Free Scan", context);
          }
          if (widget.type == "API Scan") {
            //  var result=await Provider.of<ProviderController>(context, listen: false).searchInTableScanLog(_barcodeScanned);
            //  print("result----${result}");

            // Provider.of<RegistrationController>(context, listen: false).postData(
            //     _barcodeScanned, formattedDate, context, 0, 3, "API Scan");
          }

          controller.resumeCamera();
          // await BarcodeDB.instance
          //     .queryQtyUpdate(_barcodeScanned, formattedDate, count);
          // widget.strcontroller!.add(true);
          // _scanCode = false;
        }
      }
      // }
    });
  }
}

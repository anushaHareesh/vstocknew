import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/commonColor.dart';

import 'package:vstock/controller/barcodeController.dart';

import 'package:vstock/components/shareFile.dart';

import 'package:vstock/screen/5_scanScreen.dart';
import 'package:vstock/screen/tableList.dart';
import 'package:vstock/services/dbHelper.dart';

import '../controller/registrationController.dart';

class ScanListBarcode extends StatefulWidget {
  String type;
  String comName;
  ScanListBarcode({required this.type, required this.comName});

  @override
  State<ScanListBarcode> createState() => _ScanListBarcodeState();
}

class _ScanListBarcodeState extends State<ScanListBarcode> {
  late List<List<dynamic>> scan1;
  String? comName;

  ShareFilePgm shareFilePgm = ShareFilePgm();
  @override
  void initState() {
    scan1 = List<List<dynamic>>.empty(growable: true);
    Provider.of<BarcodeController>(context, listen: false).getDataFromScanLog();

    // print("sca11------$res");

    // TODO: implement initState
    super.initState();
    print("comName--xccx---${widget.type}");

    // getComDetails();
  }

  getComDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    comName = pref.getString('companyName');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorThemeComponent.color3,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: ColorThemeComponent.color3,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorThemeComponent.color3,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          widget.comName.toString(),
          style: TextStyle(
              color: ColorThemeComponent.color3, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[Color.fromARGB(255, 28, 13, 31),
                                    Color.fromARGB(255, 68, 164, 241)],
            ),
          ),
        ),
        // Consumer<RegistrationController>(
        //   builder: (context, value, child) {
        //     return Text(
        //       value.comName.toString(),
        //       style: GoogleFonts.aBeeZee(
        //           textStyle: TextStyle(
        //               fontSize: 20,
        //               color: ColorThemeComponent.newclr,
        //               fontWeight: FontWeight.bold)),
        //       // style: TextStyle(color: ColorThemeComponent.appbr),
        //     );
        //   },
        // ),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       controller.add(true);
          //     },
          //     icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              List<Map<String, dynamic>> list =
                  await VstockDB.instance.getListOfTables();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TableList(list: list)),
              );
            },
            icon: Icon(
              Icons.table_bar,
              color: ColorThemeComponent.color4,
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            elevation: 20,
            enabled: true,
            onSelected: (value) async {
              shareFilePgm.onShareCsv(context, scan1, widget.type);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Share csv",
                  style: TextStyle(
                    color: ColorThemeComponent.color4,
                  ),
                ),
                value: "first",
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            // backgroundColor: ColorThemeComponent.newclr,
            onPressed: () {
              Provider.of<BarcodeController>(context, listen: false)
                  .countFrombarcode();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScanBarcode(
                          type: widget.type,
                        )),
              );
            },
            child: Icon(
              Icons.scanner,
              color: ColorThemeComponent.color3,
              size: 30,
            ),
          ),
        ],
      ),
      body: Consumer<BarcodeController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (value.scanList.length == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: Image.asset(
                        'asset/nodata.png',
                        height: 70,
                        width: 100,
                        // color: ColorThemeComponent,
                      ),
                    ),
                  ),
                  Text(
                    "No data !!!",
                    style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                      fontSize: 18,
                      color: ColorThemeComponent.greyclr,
                    )),
                  )
                ],
              );
            } else {
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: size.height * 0.05,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Barcode",
                                  style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                    fontSize: 18,
                                    color: ColorThemeComponent.color4,
                                  )),
                                ),
                                // Spacer(),
                                Text(
                                  "Date & Time",
                                  style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                    fontSize: 18,
                                    color: ColorThemeComponent.color4,
                                  )),
                                ),
                                // Spacer(),
                                Text(
                                  "Qty",
                                  style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                    fontSize: 18,
                                    color: ColorThemeComponent.color4,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: value.scanList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      // flex: 3,
                                      child: Container(
                                        width: size.width * 0.4,
                                        child: Text(
                                          value.scanList[index]['barcode'],
                                          style: TextStyle(
                                              color:
                                                  ColorThemeComponent.clrgrey,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    // Spacer(),
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        value.scanList[index]['date'] +
                                            ' ' +
                                            value.scanList[index]['time'],
                                        style: TextStyle(
                                            color: ColorThemeComponent.clrgrey,
                                            fontSize: 15),
                                      ),
                                    ),
                                    widget.type == "Free Scan with quantity" ||
                                            widget.type ==
                                                "API Scan with quantity"
                                        ? Flexible(
                                            child: Container(
                                              width: size.width * 0.1,
                                              child: TextField(
                                                autofocus: true,
                                                onTap: () {
                                                  // Provider.of<Controller>(context,
                                                  //         listen: false)
                                                  //     .addDeletebagItem(
                                                  //         itemId,
                                                  //         srate1.toString(),
                                                  //         srate2.toString(),
                                                  //         value.qty[index].text,
                                                  //         "0",
                                                  //         "0",
                                                  //         context,
                                                  //         "save");

                                                  value.qty[index].selection =
                                                      TextSelection(
                                                          baseOffset: 0,
                                                          extentOffset: value
                                                              .qty[index]
                                                              .value
                                                              .text
                                                              .length);
                                                },

                                                // autofocus: true,
                                                style: GoogleFonts.aBeeZee(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                  fontSize: 17,
                                                  // fontWeight: FontWeight.bold,
                                                  // color: P_Settings.loginPagetheme,
                                                ),
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  //border: InputBorder.none
                                                ),

                                                // maxLines: 1,
                                                // minLines: 1,
                                                keyboardType:
                                                    TextInputType.number,
                                                onSubmitted: (values) async {
                                                  await VstockDB.instance
                                                      .updateCommonQuery(
                                                          " tableScanLog",
                                                          " qty = '${values}'",
                                                          " where barcode='${value.scanList[index]['barcode']}'");
                                                  print("values----$values");
                                                  double valueqty = 0.0;
                                                  // value.discount_amount[index].text=;
                                                  if (values.isNotEmpty) {
                                                    print("emtyyyy");
                                                    valueqty =
                                                        double.parse(values);
                                                  } else {
                                                    valueqty = 0.00;
                                                  }
                                                },
                                                textAlign: TextAlign.right,
                                                controller: value.qty[index],
                                              ),
                                            ),
                                          )
                                        : Flexible(
                                            // flex: 1,
                                            child: Text(
                                              value.scanList[index]['qty']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: ColorThemeComponent
                                                      .clrgrey,
                                                  fontSize: 15),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
        },
      ),
      // body: Consumer<RegistrationController>(
      //   builder: (context, value, child) {
      //     return SingleChildScrollView(
      //       scrollDirection: Axis.vertical,
      //       child: value.listResult.length == 0
      //           ? Container(
      //               height: size.height * 0.8,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 // crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   Container(
      //                     child: Center(
      //                       child: Image.asset(
      //                         "asset/No.png",
      //                         color: ColorThemeComponent.color4,
      //                         height: size.height * 0.2,
      //                         width: size.width * 0.2,
      //                       ),
      //                     ),
      //                   ),
      //                   Text(
      //                     'No data!!!',
      //                     style: TextStyle(fontSize: 18),
      //                   )
      //                 ],
      //               ),
      //             )
      //           : Container(
      //               alignment:
      //                   widget.type == "Free Scan" || widget.type == "API Scan"
      //                       ? Alignment.center
      //                       : null,
      //               child: DataTable(
      //                 columnSpacing: widget.type == "Free Scan" ||
      //                         widget.type == "API Scan"
      //                     ? 40
      //                     : 30,
      //                 columns: [
      //                   // DataColumn(label: Text("id")),
      //                   DataColumn(label: Text("barcode")),
      //                   DataColumn(label: Text("time")),
      //                   if (widget.type == "Free Scan with quantity" ||
      //                       widget.type == "API Scan with quantity")
      //                     DataColumn(label: Text("qty")),
      //                   DataColumn(label: Text("")),
      //                   // DataColumn(label: Text("")),

      //                   // DataColumn(label: Text("id")),
      //                 ],
      //                 rows: value.listResult
      //                     .map(
      //                       (e) => DataRow(cells: [
      //                         // DataCell(Text(e["id"].toString())),
      //                         DataCell(Text(e["barcode"].toString())),
      //                         DataCell(Text(e["time"].toString())),
      //                         // DataCell(TextField()),
      //                         // if (widget.type == "Free Scan" ||
      //                         //     widget.type == "API Scan")
      //                         //   DataCell(Text(e["qty"].toString())),

      //                         if (widget.type == "Free Scan with quantity" ||
      //                             widget.type == "API Scan with quantity")
      //                           DataCell(
      //                               TextFormField(
      //                                 // controller: _controllertext,
      //                                 // initialValue: "${e["qty"]}",
      //                                 keyboardType: TextInputType.number,
      //                                 decoration: InputDecoration(
      //                                     border: InputBorder.none,
      //                                     hintText: "1"),
      //                                 // onChanged: (value) {
      //                                 //   Provider.of<ProviderController>(context,
      //                                 //           listen: false)
      //                                 //       .setUpdatedQty(value);
      //                                 // },
      //                                 onFieldSubmitted: (val) {
      //                                   Provider.of<RegistrationController>(
      //                                           context,
      //                                           listen: false)
      //                                       .updateTableScanLog(val, e["id"]);
      //                                   // Provider.of<ProviderController>(context,
      //                                   //         listen: false)
      //                                   //     .setUpdatedQty(val);
      //                                   // print('onSubmited $val');
      //                                 },
      //                               ),
      //                               showEditIcon: true),

      //                         DataCell(Container(
      //                           // width: 5,
      //                           child: IconButton(
      //                               onPressed: () {
      //                                 // _showDialog(context, "single", e["id"]);
      //                               },
      //                               icon: Icon(Icons.delete)),
      //                         )),
      //                         // DataCell(Container(
      //                         //   // width: 5,
      //                         //   child: IconButton(
      //                         //       onPressed: () {
      //                         //         print("edit clicked");
      //                         //         updatedQty=Provider.of<ProviderController>(context,
      //                         //                 listen: false).updatedQty;
      //                         //         print('updatedQty $updatedQty');

      //                         //         Provider.of<ProviderController>(context,
      //                         //                 listen: false)
      //                         //             .updateTableScanLog(updatedQty,e["id"]);
      //                         //       },
      //                         //       icon: Icon(Icons.done),
      //                         //       color: Colors.green,
      //                         //       ),
      //                         // )),
      //                         // DataCell(TextField())
      //                       ]),
      //                     )
      //                     .toList(),
      //               ),
      //             ),
      //     );
      //   },
      // ),
    );
  }
}

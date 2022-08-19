import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/waveclipper.dart';
import 'package:vstock/screen/4_barcodeScan_list.dart';

class ScanType extends StatefulWidget {
  @override
  State<ScanType> createState() => _ScanTypeState();
}

class _ScanTypeState extends State<ScanType> {
  List<String> types = [
    "Free Scan",
    "Free Scan with quantity",
    "API Scan",
    "API Scan with quantity"
  ];
  int? tappedIndex;
  late List<Map<String, dynamic>> queryresult;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorThemeComponent.color3,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Select Scan Type",
          style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
            fontSize: 20,
            color: ColorThemeComponent.color3,
          )),
        ),
        backgroundColor: Color.fromARGB(255, 201, 62, 19),
        // elevation: 0,
      ),
      drawer: Drawer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.045,
                  ),
                  Container(
                    height: size.height * 0.1,
                    width: size.width * 1,
                    color: ColorThemeComponent.newclr,
                    child: Row(
                      children: [
                        SizedBox(
                          height: size.height * 0.07,
                          width: size.width * 0.03,
                        ),
                        Icon(
                          Icons.list_outlined,
                          color: ColorThemeComponent.color4,
                        ),
                        SizedBox(width: size.width * 0.04),
                        Text(
                          "Menus",
                          style: TextStyle(
                              fontSize: 20, color: ColorThemeComponent.color3),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.download,
                          color: ColorThemeComponent.color4,
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Text(
                          "Download",
                          style: TextStyle(
                              fontSize: 17, color: ColorThemeComponent.newclr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                // SizedBox(
                //   height: size.height * 0.04,
                // ),
                Stack(
                  children: [
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper:
                                WaveClipper(), //set our custom wave clipper.
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom: 50,
                              ),
                              color: Color.fromARGB(255, 201, 62, 19),
                              height: size.height * 0.2,
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Image.asset(
                    //   'asset/barcode.png',
                    //   width: 100.0,
                    //   height: 100.0,
                    //   fit: BoxFit.cover,
                    // ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: types.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 1,
                            color: Color.fromARGB(255, 255, 254, 252),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onTap: () async {
                                setState(() {
                                  tappedIndex = index;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanListBarcode(
                                            type: types[index],
                                            // queryresult: queryresult,
                                          )),
                                );
                              },
                              title: Row(
                                children: [
                                  Image.asset(
                                    'asset/barbox.png',
                                    width: 30.0,
                                    height: 30.0,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.04,
                                  ),
                                  Text(
                                    types[index],
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                      fontSize: 20,
                                      color: ColorThemeComponent.color4,
                                    )),
                                    // style: TextStyle(
                                    //   // fontFamily: "fantasy",
                                    //   fontSize: 22,
                                    //   color: ColorThemeComponent.color4,
                                    //   // color: tappedIndex == index
                                    //   //     ? Colors.black
                                    //   //     : Colors.white
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

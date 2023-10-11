import 'package:app_project/addlocation_page.dart';
import 'package:app_project/carlendar_page.dart';
import 'package:app_project/user_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:app_project/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fluttertoast/fluttertoast.dart';

final firestoreReference = FirebaseFirestore.instance;
StreamSubscription<QuerySnapshot<Object?>>? _streamSubscription = null;

String? _selectedDocId;

class getdocId {
  static var docid;
}

class FarmPage extends StatelessWidget {
  const FarmPage({super.key});
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "th";
    initializeDateFormatting();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          home: Farm_page(),
        );
      },
    );
  }
}

final FirebaseAuth auth = FirebaseAuth.instance;
User? userData = auth.currentUser;

class Farm_page extends StatefulWidget {
  const Farm_page({super.key});

  @override
  State<Farm_page> createState() => _Farm_pageState();
}

class _Farm_pageState extends State<Farm_page> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Completer<GoogleMapController> _controller2 =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.3082772, 98.3790378),
    zoom: 8.88,
  );

  final farmNamecontroller = TextEditingController();
  var size = 0.5;
  var farmSize = 0.5;
  void _addFarmDialog() {
    slideDialog.showSlideDialog(
        context: context,
        child: Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: 1.sh,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.25, 0.9, 0.93],
                colors: [
                  HexColor("#FFFFF"),
                  Colors.black,
                  Colors.black,
                ],
              )),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('เพิ่มสวน',
                        style: GoogleFonts.notoSansThai(
                          textStyle: TextStyle(
                              color: HexColor("#2F4858"),
                              letterSpacing: .25,
                              fontWeight: FontWeight.w600,
                              fontSize: 28.sp),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 0.04.sw),
                      child: SizedBox(
                        width: 0.75.sw,
                        height: 0.06.sh,
                        child: TextFormField(
                          controller: farmNamecontroller,
                          cursorColor: HexColor("#067D68"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("#D9D9D9"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'ชื่อสวน',
                            hintStyle: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0.04.sw, left: 0.15.sw, right: 0.15.sw),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ขนาด",
                            style: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: HexColor("#00000"),
                                  letterSpacing: .25,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                            ),
                          ),
                          SizedBox(
                              width: 0.4.sw,
                              height: 0.06.sh,
                              child: SpinBox(
                                decimals: 1,
                                step: 0.5,
                                min: 0.5,
                                max: 2,
                                value: size.toDouble(),
                                onChanged: (size) => setState(() {
                                  farmSize = size;
                                  print(farmSize);
                                }),
                              )),
                          Text(
                            "ไร่",
                            style: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: HexColor("#00000"),
                                  letterSpacing: .25,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* Padding(
                      padding: EdgeInsets.only(
                          top: 0.04.sw, left: 0.15.sw, right: 0.15.sw),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "ระบุที่อยู่สวน",
                            style: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: HexColor("#00000"),
                                  letterSpacing: .25,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                            ),
                          ),
                          SizedBox(
                            width: 0.04.sw,
                          ),
                          Bounceable(
                            child: Container(
                                height: 0.1.sw,
                                width: 0.1.sw,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: HexColor("#389786"),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1.3,
                                      blurRadius: 1.3,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Ionicons.location,
                                  size: 0.07.sw,
                                  color: Colors.white,
                                )),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ), */
                    Padding(
                      padding: EdgeInsets.only(top: 0.07.sw),
                      child: SizedBox(
                        width: 0.75.sw,
                        height: 0.05.sh,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#067D68"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 3),
                          onPressed: () {
                            setState(() {
                              if (farmNamecontroller.text.trim().isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "กรุณากรอกชื่อสวน",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 10.sp);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "เพิ่มสวนสำเร็จ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 10.sp);
                                saveFarm();
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: Text(
                            'ยืนยัน',
                            style: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: HexColor("#FFFFFF"),
                                  letterSpacing: .25,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
  void _editFarmDialog() {
    slideDialog.showSlideDialog(
        context: context,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Farm").doc(_selectedDocId).snapshots(),
          builder: (context, snapshot) {
             if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
     String farmName = snapshot.data != null ? snapshot.data!['FarmName'] : '';
     double farmSize = snapshot.data != null ? snapshot.data!['FarmSize'] : 0.0;
    farmNamecontroller.text = farmName;

            return Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: 1.sh,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.25, 0.9, 0.93],
                    colors: [
                      HexColor("#FFFFF"),
                      Colors.black,
                      Colors.black,
                    ],
                  )),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('แก้ไขสวน',
                            style: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: HexColor("#2F4858"),
                                  letterSpacing: .25,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28.sp),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 0.04.sw),
                          child: SizedBox(
                            width: 0.75.sw,
                            height: 0.06.sh,
                            child: TextFormField(
                              controller: farmNamecontroller,
                              cursorColor: HexColor("#067D68"),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: HexColor("#D9D9D9"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'ชื่อสวน',
                                hintStyle: GoogleFonts.notoSansThai(
                                  textStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.04.sw, left: 0.15.sw, right: 0.15.sw),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ขนาด",
                                style: GoogleFonts.notoSansThai(
                                  textStyle: TextStyle(
                                      color: HexColor("#00000"),
                                      letterSpacing: .25,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp),
                                ),
                              ),
                              SizedBox(
                                  width: 0.4.sw,
                                  height: 0.06.sh,
                                  child: SpinBox(
                                    decimals: 1,
                                    step: 0.5,
                                    min: 0.5,
                                    max: 2,
                                    value: farmSize.toDouble(),
                                    onChanged: (size) => setState(() {
                                      farmSize = size;
                                      print(farmSize);
                                    }),
                                  )),
                              Text(
                                "ไร่",
                                style: GoogleFonts.notoSansThai(
                                  textStyle: TextStyle(
                                      color: HexColor("#00000"),
                                      letterSpacing: .25,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.07.sw),
                          child: SizedBox(
                            width: 0.75.sw,
                            height: 0.05.sh,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#067D68"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 3),
                              onPressed: () {
                                setState(() {
                                  if (farmNamecontroller.text.trim().isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "กรุณากรอกชื่อสวน",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 10.sp);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "แก้ไขสวนสำเร็จ",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 10.sp);
                                    updateFarm(_selectedDocId!, farmNamecontroller.text, farmSize);
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Text(
                                'ยืนยัน',
                                style: GoogleFonts.notoSansThai(
                                  textStyle: TextStyle(
                                      color: HexColor("#FFFFFF"),
                                      letterSpacing: .25,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ));
  }

  @override
  Widget build(BuildContext context) {
    void initState() {
      super.initState();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: HexColor("#f0ecec"),
      body: Wrap(
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.1,
                      scale: 0.9,
                      alignment: Alignment.bottomLeft,
                      image: AssetImage("assets/images/logo.png")),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [
                      0.15,
                      0.95,
                    ],
                    colors: [
                      HexColor("#067D68"),
                      HexColor("#1c2b35"),
                    ],
                  )),
              child: Container(
                height: 0.3.sh,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.sw, 0.17.sw, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0.02.sw,
                        width: 1.sw,
                      ),
                      Text(
                        "รายการสวน",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansThai(
                          textStyle: TextStyle(
                              color: HexColor("#FFFFFF"),
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                              fontSize: 28.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.015.sw, left: 0.1.sw),
                        child: FadeInRight(
                          child: Container(
                            height: 0.25.sw,
                            child: StreamBuilder(
                              stream: firestoreReference
                                  .collection("Farm")
                                  .where('Farmer',
                                      isEqualTo: auth.currentUser?.uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: snapshot.data.docs
                                      .map<Widget>((document) {
                                    if (_selectedDocId == null) {
                                      _selectedDocId = document.id;
                                    }
                                    String docId =
                                        document.id; // get the document ID
                                    return Row(
                                      children: [
                                        Bounceable(
                                          onTap: () {
                                            setState(() {
                                              _selectedDocId = document.id;
                                              print(_selectedDocId);
                                            });
                                            print(
                                                docId); // print the document ID when tapping on the widget
                                          },
                                          child: Container(
                                            width: 0.25.sw,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1.3,
                                                  blurRadius: 1.3,
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ],
                                              color:
                                                  _selectedDocId == document.id
                                                      ? HexColor("#067D68")
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0.025.sw),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  if (_selectedDocId ==
                                                      document.id) ...[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0.02.sw,
                                                          right: 0.02.sw),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Bounceable(
                                                            onTap: () {
                                                              _editFarmDialog();
                                                            },
                                                            child: Container(
                                                                height: 0.05.sw,
                                                                width: 0.05.sw,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.5),
                                                                            spreadRadius:
                                                                                0.3,
                                                                            blurRadius:
                                                                                1.3,
                                                                            offset:
                                                                                Offset(0, 2), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(30))),
                                                                child: Icon(
                                                                  Icons.edit,
                                                                  color: HexColor(
                                                                      "#067D68"),
                                                                  size: 0.03.sw,
                                                                )),
                                                          ),
                                                          Bounceable(
                                                              onTap: () {
                                                                showDialog<
                                                                    String>(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(30))),
                                                                    title: Text(
                                                                      "ลบสวน",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: GoogleFonts
                                                                          .notoSansThai(
                                                                        textStyle: TextStyle(
                                                                            color: HexColor(
                                                                                "#00000"),
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize: 18.sp),
                                                                      ),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "คุณต้องการลบสวนใช่หรือไม่?",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: GoogleFonts
                                                                          .notoSansThai(
                                                                        textStyle: TextStyle(
                                                                            color: HexColor(
                                                                                "#00000"),
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontSize: 14.sp),
                                                                      ),
                                                                    ),
                                                                    actionsAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'Cancel'),
                                                                        child:
                                                                            Text(
                                                                          "ยกเลิก",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              GoogleFonts.notoSansThai(
                                                                            textStyle: TextStyle(
                                                                                color: Colors.red,
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 14.sp),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('Farm')
                                                                              .doc(_selectedDocId.toString())
                                                                              .delete();
                                                                          Navigator.pop(
                                                                              context,
                                                                              'OK');
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "ตกลง",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              GoogleFonts.notoSansThai(
                                                                            textStyle: TextStyle(
                                                                                color: HexColor("#00000"),
                                                                                letterSpacing: 0,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 14.sp),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              child: Icon(
                                                                Ionicons
                                                                    .remove_circle,
                                                                color: Colors
                                                                    .white,
                                                                size: 0.06.sw,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  Container(
                                                    child: Image(
                                                      image: AssetImage(
                                                          "assets/images/tree.png"),
                                                    ),
                                                    width: 0.11.sw,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      document["FarmName"],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts
                                                          .notoSansThai(
                                                        textStyle: TextStyle(
                                                          color:
                                                              _selectedDocId ==
                                                                      document
                                                                          .id
                                                                  ? Colors.white
                                                                  : HexColor(
                                                                      "#045849"),
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 0.02.sw),
                                      ],
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          StreamBuilder(
              stream: firestoreReference
                  .collection("Farm")
                  .where('Farmer', isEqualTo: auth.currentUser?.uid)
                  .where(FieldPath.documentId, isEqualTo: _selectedDocId)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center();
                } else if (snapshot.hasData) {
                  if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                    var docData = snapshot.data.docs[0].data();
                    if (docData.containsKey('Location') &&
                        docData['Location'] != null) {
                      String locationString = docData['Location'];
                      String latLngWithoutPrefix = locationString
                          .replaceAll("LatLng(", "")
                          .replaceAll(')', '');
                      ;
                      List<dynamic> latLngStrings =
                          latLngWithoutPrefix.split(", ");
                      double lat = double.parse(latLngStrings[0]);
                      double lng = double.parse(latLngStrings[1]);
                      LatLng latLng = LatLng(lat, lng);
                      return Padding(
                        padding: EdgeInsets.only(left: 0.05.sw, top: 0.04.sw),
                        child: Container(
                          width: 0.9.sw,
                          height: 1.sh,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: /* _kGooglePlex, */
                                CameraPosition(target: latLng, zoom: 15),
                            onMapCreated: (GoogleMapController controller) {
                              if (!_controller.isCompleted) {
                                _controller.complete(controller);
                              }
                            },
                            markers: Set<Marker>.of([
                              Marker(
                                markerId: MarkerId('myMarker'),
                                position: latLng,
                                infoWindow: InfoWindow(title: 'My Location'),
                              ),
                            ]),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 0.5.sw, left: 0.15.sw, right: 0.15.sw),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "ระบุพิกัดสวน",
                                style: GoogleFonts.notoSansThai(
                                  textStyle: TextStyle(
                                      color: HexColor("#00000"),
                                      letterSpacing: .25,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp),
                                ),
                              ),
                              Text(
                                "แตะเพื่อระบุพิกัดสวน",
                                style: GoogleFonts.notoSansThai(
                                  textStyle: TextStyle(
                                      color: HexColor("#00000"),
                                      letterSpacing: .25,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.sp),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.04.sw),
                                child: Bounceable(
                                  child: Container(
                                    height: 0.1.sw,
                                    width: 0.35.sw,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: HexColor("#389786"),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1.3,
                                          blurRadius: 1.3,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0.01.sw),
                                      child: Text(
                                        "ระบุพิกัด",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.notoSansThai(
                                          textStyle: TextStyle(
                                              color: HexColor("#FFFFFF"),
                                              letterSpacing: .25,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    getdocId.docid = _selectedDocId;
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                Addlocation_page(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 0.5.sw, left: 0.15.sw, right: 0.15.sw),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "ไม่พบข้อมูลสวน",
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: HexColor("#00000"),
                                    letterSpacing: .25,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp),
                              ),
                            ),
                            Text(
                              "แตะเพื่อเพิ่มข้อมูลสวน",
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: HexColor("#00000"),
                                    letterSpacing: .25,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15.sp),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.04.sw),
                              child: Bounceable(
                                child: Container(
                                  height: 0.1.sw,
                                  width: 0.35.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: HexColor("#389786"),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1.3,
                                        blurRadius: 1.3,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.01.sw),
                                    child: Text(
                                      "เพิ่มสวน",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#FFFFFF"),
                                            letterSpacing: .25,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _addFarmDialog();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return Container();
              })
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 0.075.sh,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0.02.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 0.1.sw),
                          child: Container(
                            width: 0.12.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  constraints: BoxConstraints(),
                                  icon: Icon(Ionicons.home_outline),
                                  color: HexColor("#067D68"),
                                  padding: EdgeInsets.zero,
                                  iconSize: 0.07.sw,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              homepage(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    });
                                  },
                                ),
                                Text(
                                  "หน้าหลัก",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#067D68"),
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(right: 0.sw),
                          child: Container(
                            width: 0.12.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  constraints: BoxConstraints(),
                                  icon: Icon(Ionicons.calendar_number_outline),
                                  color: HexColor("#067D68"),
                                  padding: EdgeInsets.zero,
                                  iconSize: 0.07.sw,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              carlendar_page(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    });
                                  },
                                ),
                                Text(
                                  "ปฏิทิน",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#067D68"),
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0.02.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 0.sw),
                          child: Container(
                            width: 0.12.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  constraints: BoxConstraints(),
                                  icon: Icon(Ionicons.person_circle_outline),
                                  color: HexColor("#067D68"),
                                  padding: EdgeInsets.zero,
                                  iconSize: 0.07.sw,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              UsermenuPage(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    });
                                  },
                                ),
                                Text(
                                  "บัญชี",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#067D68"),
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 0.1.sw),
                          child: Container(
                            width: 0.12.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  constraints: BoxConstraints(),
                                  icon: Icon(Ionicons.log_out_outline),
                                  color: HexColor("#067D68"),
                                  padding: EdgeInsets.zero,
                                  iconSize: 0.07.sw,
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        title: Text(
                                          "ออกระบบ",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.notoSansThai(
                                            textStyle: TextStyle(
                                                color: HexColor("#00000"),
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.sp),
                                          ),
                                        ),
                                        content: Text(
                                          "คุณต้องการออกจากระบบใช่หรือไม่?",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.notoSansThai(
                                            textStyle: TextStyle(
                                                color: HexColor("#00000"),
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.sp),
                                          ),
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: Text(
                                              "ยกเลิก",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.notoSansThai(
                                                textStyle: TextStyle(
                                                    color: Colors.red,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context, 'OK');
                                              _streamSubscription?.cancel();
                                              print(_streamSubscription);
                                              await FirebaseFirestore.instance
                                                  .terminate();
                                              await FirebaseAuth.instance
                                                  .signOut()
                                                  .then((value) {
                                                Navigator.pop(context);
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        child: mainPage()));
                                              });
                                            },
                                            child: Text(
                                              "ตกลง",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.notoSansThai(
                                                textStyle: TextStyle(
                                                    color: HexColor("#00000"),
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                                Text(
                                  "ออกระบบ",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#067D68"),
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#067D68"),
        onPressed: () => setState(() {
          print(auth.currentUser?.uid);
          _addFarmDialog();
        }),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> saveFarm() async {
    DateTime datenow = new DateTime.now();
    DateFormat dateformat = DateFormat.yMMMMd();
    var dateCreate = dateformat.formatInBuddhistCalendarThai(datenow);
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance.collection('Farm').add({
        'FarmName': farmNamecontroller.text.trim(),
        'FarmSize': farmSize,
        'DateCreate': dateCreate.toString(),
        'Farmer': auth.currentUser?.uid,
        'Location': null,
      });
    });
  }

  void updateFarm(String id, String newName, double newSize) async {
  try {
    await FirebaseFirestore.instance
        .collection('Farm')
        .doc(id)
        .update({'FarmName': newName, 'FarmSize': newSize});
    print('Farm document updated successfully.');
  } catch (e) {
    print('Error updating Farm document: $e');
  }
}
}

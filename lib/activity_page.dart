import 'package:app_project/main.dart';
import 'package:app_project/user_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'carlendar_page.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:page_transition/page_transition.dart';

final firestoreReference = FirebaseFirestore.instance;
String? _selectedDocId;

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          home: Activity_page(),
        );
      },
    );
  }
}

class Activity_page extends StatefulWidget {
  const Activity_page({super.key});

  @override
  State<Activity_page> createState() => _Activity_pageState();
}

class _Activity_pageState extends State<Activity_page> {
  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.fromLTRB(0.sw, 0.212.sw, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0.02.sw,
                        width: 1.sw,
                      ),
                      Text(
                        "ประวัติกิจกรรม",
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
                                      _selectedDocId = document['FarmName'];
                                    }
                                    String docId =
                                        document.id; // get the document ID
                                    return Row(
                                      children: [
                                        Bounceable(
                                          onTap: () {
                                            setState(() {
                                              _selectedDocId =
                                                  document['FarmName'];
                                            }); // print the document ID when tapping on the widget
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
                                              color: _selectedDocId ==
                                                      document['FarmName']
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
                                                          color: _selectedDocId ==
                                                                  document[
                                                                      'FarmName']
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
                  .collection("activityEvents")
                  .where('Farmer', isEqualTo: auth.currentUser?.uid)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                    height: 0.7.sh,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 0.04.sw, left: 0.05.sw, right: 0.05.sw),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map<Widget>(
                          (QueryDocumentSnapshot<Map<String, dynamic>>
                              myEvents) {
                        int check = 0;
                        final events = myEvents["detail"];
                        if (events is Map<String, dynamic>) {
                          final eventlist =
                              events.values.expand((events) => events).toList();
                          if (eventlist is List<dynamic>) {
                            var dateEvent = events.keys
                                .toString()
                                .replaceAll("(", "")
                                .replaceAll(")", "");
                            DateTime dateObj = DateTime.parse(dateEvent);
                            String formattedDate =
                                DateFormat('dd MMMM yyyy').format(dateObj);
                            var selectedEvents = eventlist
                                .where(
                                    (event) => event['Farm'] == _selectedDocId)
                                .toList();
                            selectedEvents.forEach((event) {
                              print(event);
                            });
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: eventlist
                                  .where((event) =>
                                      event['Farm'] == _selectedDocId).where((event) =>
                                      event['status'] == 'completed')
                                  .map((event) {
                                print(event);
                                return Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 0.03.sw),
                                      child: event['status'] == 'completed'
                                          ? ListTile(
                                              visualDensity: VisualDensity(
                                                  horizontal: 0, vertical: 0),
                                              contentPadding: EdgeInsets.only(
                                                  bottom: 0.02.sw),
                                              tileColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              trailing: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 0.025.sw),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.done_all,
                                                      color: Colors.green[400],
                                                      size: 0.08.sw,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              leading: Wrap(
                                                children: [
                                                  SizedBox(
                                                    width: 0.02.sw,
                                                  ),
                                                  if (event['eventTitle']
                                                          .toString() ==
                                                      'ให้น้ำ') ...[
                                                    Container(
                                                      width: 0.15.sw,
                                                      height: 0.15.sw,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topRight,
                                                            end: Alignment
                                                                .bottomLeft,
                                                            colors: [
                                                              HexColor(
                                                                  "#00BFFF"),
                                                              HexColor(
                                                                  "#000080"),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Icon(
                                                        Ionicons.water,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ] else if (event['eventTitle']
                                                          .toString() ==
                                                      'พ่นสารเคมี') ...[
                                                    Container(
                                                      width: 0.15.sw,
                                                      height: 0.15.sw,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topRight,
                                                            end: Alignment
                                                                .bottomLeft,
                                                            colors: [
                                                              HexColor(
                                                                  "#800080"),
                                                              HexColor(
                                                                  "#1d1160"),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Icon(
                                                        Ionicons.flask_outline,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ] else if (event['eventTitle']
                                                          .toString() ==
                                                      'ใส่ปุ๋ย') ...[
                                                    Container(
                                                      width: 0.15.sw,
                                                      height: 0.15.sw,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Icon(
                                                        Ionicons.leaf_outline,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ] else if (event['eventTitle']
                                                          .toString() ==
                                                      'ตัดแต่งกิ่ง') ...[
                                                    Container(
                                                      width: 0.15.sw,
                                                      height: 0.15.sw,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topRight,
                                                            end: Alignment
                                                                .bottomLeft,
                                                            colors: [
                                                              HexColor(
                                                                  "#b6773b"),
                                                              HexColor(
                                                                  "#673400"),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Icon(
                                                        Ionicons.cut_outline,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ] else if (event['eventTitle']
                                                          .toString() ==
                                                      'เก็บเกี่ยว') ...[
                                                    Container(
                                                      width: 0.15.sw,
                                                      height: 0.15.sw,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topRight,
                                                            end: Alignment
                                                                .bottomLeft,
                                                            colors: [
                                                              HexColor(
                                                                  "#FEBE10"),
                                                              HexColor(
                                                                  "#B5651D"),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Icon(
                                                        Ionicons.basket_outline,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formattedDate,
                                                    style: GoogleFonts
                                                        .notoSansThai(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.sp),
                                                    ),
                                                  ),
                                                  if (event['Note']
                                                          .toString() !=
                                                      "") ...[
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'หมายเหตุ: ',
                                                          style: GoogleFonts
                                                              .notoSansThai(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            event['Note']
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .notoSansThai(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ] else if (event['Note']
                                                          .toString() ==
                                                      "") ...[
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'หมายเหตุ: ',
                                                          style: GoogleFonts
                                                              .notoSansThai(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            '-'.toString(),
                                                            style: GoogleFonts
                                                                .notoSansThai(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]
                                                ],
                                              ),
                                              title: Padding(
                                                padding: EdgeInsets.all(0.0.sw),
                                                child: Text(
                                                  event['eventTitle']
                                                      .toString(),
                                                  style:
                                                      GoogleFonts.notoSansThai(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 18.sp),
                                                  ),
                                                ),
                                              ))
                                          : null,
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          } else {
                            return Text('No events found.');
                          }
                        } else {
                          return Container();
                        }
                      }).toList(),
                    ));
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
                                              /*  _streamSubscription?.cancel();
                                              print(_streamSubscription); */
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
/*       floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#067D68"),
        onPressed: () => setState(() {}),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ), */
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

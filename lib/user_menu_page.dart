import 'package:app_project/activity_page.dart';
import 'package:app_project/carlendar_page.dart';
import 'package:app_project/farm_page.dart';
import 'package:app_project/home_page.dart';
import 'package:app_project/main.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';

class MenuUser extends StatelessWidget {
  const MenuUser({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          home: UsermenuPage(),
        );
      },
    );
  }
}

class UsermenuPage extends StatefulWidget {
  const UsermenuPage({super.key});

  @override
  State<UsermenuPage> createState() => _UsermenuPageState();
}

class _UsermenuPageState extends State<UsermenuPage> {
  DateTime? getcreateDate =
      FirebaseAuth.instance.currentUser!.metadata.creationTime;
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
                  padding: EdgeInsets.fromLTRB(0.sw, 0.3.sw, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0.02.sw,
                        width: 1.sw,
                      ),
                      Text(
                        "ข้อมูลบัญชีผู้ใช้",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansThai(
                          textStyle: TextStyle(
                              color: HexColor("#FFFFFF"),
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                              fontSize: 28.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          /*  Center(
            child: Padding(
              padding: EdgeInsets.only(top: 0.02.sw, left: 0.0.sw),
              child: Text(
                auth.currentUser!.email.toString().split("@gmail").first,
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSansThai(
                  textStyle: TextStyle(
                      color: HexColor("#00000"),
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp),
                ),
              ),
            ),
          ), */
          Padding(
            padding:
                EdgeInsets.only(top: 0.04.sh, left: 0.07.sw, right: 0.07.sw),
            child: Center(
              child: FadeInUp(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bounceable(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Farm_page(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        });
                      },
                      child: Container(
                        width: 0.4.sw,
                        height: 0.18.sw,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1.3,
                                blurRadius: 1.3,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [
                                HexColor("#067D68"),
                                HexColor("#2F4858"),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              (Ionicons.leaf_outline),
                              size: 0.07.sw,
                              color: Colors.white,
                            ),
                            Text(
                              "สวนของคุณ",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: HexColor("#FFFFFF"),
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* Container(
                      width: 0.18.sw,
                      height: 0.18.sw,
                      decoration: BoxDecoration(
                          color: HexColor("#067D68"),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            constraints: BoxConstraints(),
                            icon: Icon(Ionicons.calculator_outline),
                            color: Colors.white,
                            padding: EdgeInsets.zero,
                            iconSize: 0.07.sw,
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          Text(
                            "การเงิน",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: HexColor("#FFFFFF"),
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp),
                            ),
                          ),
                        ],
                      ),
                    ), */
                    Bounceable(
                      onTap: () async {
                        final collection = FirebaseFirestore.instance
                            .collection('activityEvents').where('Farmer',isEqualTo: FirebaseAuth.instance.currentUser?.uid);
                        final querySnapshot = await collection.get();
                        if (querySnapshot.docs.isEmpty) {
                          // Show dialog if collection is empty
                          showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        title: Text(
                                          "ไม่พบกิจกรรม",
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
                                          "คุณยังไม่มีประวัติกิจกรรมกรุณาเพิ่มกิจกรรม หรือ ยืนยันการเสร็จสิ้นของกิจกรรม",
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
                                            onPressed: () async {
                                              Navigator.pop(context, 'OK');
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
                          return;
                        }

                        // Navigate to the 'Activity_page' if the collection is not empty
                        setState(() {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Activity_page(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        });
                      },
                      child: Container(
                        width: 0.4.sw,
                        height: 0.18.sw,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1.3,
                                blurRadius: 1.3,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [
                                HexColor("#067D68"),
                                HexColor("#2F4858"),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              (Ionicons.checkmark_circle_outline),
                              size: 0.07.sw,
                              color: Colors.white,
                            ),
                            Text(
                              "ประวัติกิจกรรม",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: HexColor("#FFFFFF"),
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* Container(
                      width: 0.18.sw,
                      height: 0.18.sw,
                      decoration: BoxDecoration(
                          color: HexColor("#067D68"),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            constraints: BoxConstraints(),
                            icon: Icon(Ionicons.bar_chart_outline),
                            color: Colors.white,
                            padding: EdgeInsets.zero,
                            iconSize: 0.07.sw,
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            UsermenuPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              });
                            },
                          ),
                          Text(
                            "รายงาน",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: HexColor("#FFFFFF"),
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp),
                            ),
                          ),
                        ],
                      ),
                    ), */
                  ],
                ),
              ),
            ),
          ),
          FadeInUp(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 0.07.sw),
                child: Container(
                  height: 0.9.sw,
                  width: 0.9.sw,
                  decoration: BoxDecoration(
                    color: HexColor("#FFFFFF"),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(1.0, 1.0), //(x,y)
                        blurRadius: 0.3,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0.04.sw),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Farm')
                            .where('Farmer',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          final count = snapshot.data!.docs.length;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ข้อมูลบัญชีผู้ใช้",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#00000"),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp),
                                      ),
                                    ),
                                    /* GestureDetector(
                                    child: Icon(
                                      Ionicons.pencil_outline,
                                      color: HexColor("#067D68"),
                                    ),
                                  ), */
                                  ],
                                ),
                                Divider(color: Colors.grey),
                                SizedBox(
                                  height: 0.04.sw,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Email :",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#00000"),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                    Text(
                                      FirebaseAuth.instance.currentUser!.email
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#00000"),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 0.04.sw,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ลงทะเบียนเมื่อ :",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#00000"),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMMMd()
                                          .format(getcreateDate!)
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#00000"),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 0.04.sw,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "จำนวนสวนทั้งหมด :",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#00000"),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                    Text(
                                      "$count สวน",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            color: HexColor("#00000"),
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                /* SizedBox(
                                height: 0.04.sw,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "สวนที่กำลังรอการดำเนินงาน :",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#00000"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                  Text(
                                    "2 สวน",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#00000"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                ],
                              ), */
                              ]);
                        }),
                  ),
                ),
              ),
            ),
          ),
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
                          child: FadeIn(
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              width: 0.12.sw,
                              decoration: BoxDecoration(
                                  color: HexColor("#067D68"),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                    constraints: BoxConstraints(),
                                    icon: Icon(Ionicons.person_circle_outline),
                                    color: Colors.white,
                                    padding: EdgeInsets.zero,
                                    iconSize: 0.07.sw,
                                    onPressed: () {
                                      setState(() {
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
                                          color: HexColor("#FFFFFF"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp),
                                    ),
                                  ),
                                ],
                              ),
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
                                              /* _streamSubscription?.cancel();
                                              print(_streamSubscription); */
                                              await FirebaseFirestore.instance
                                                  .terminate();
                                              await FirebaseAuth.instance
                                                  .signOut()
                                                  .then((value) =>
                                                      Navigator.pushReplacement(
                                                          context,
                                                          PageTransition(
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              child:
                                                                  mainPage())));
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

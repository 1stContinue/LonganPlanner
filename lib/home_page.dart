import 'package:app_project/carlendar_page.dart';
import 'package:app_project/main.dart';
import 'package:app_project/user_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:weather/weather.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

final firestoreReference = FirebaseFirestore.instance;
StreamSubscription<QuerySnapshot<Object?>>? _streamSubscription = null;
Map<String, dynamic>? _currentWeather;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          home: homepage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  void initState() {
    super.initState();
    _getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "th";
    initializeDateFormatting();
    var now = DateTime.now();
    var month = DateFormat.MMMM();
    var year = DateFormat.y();
    var day = DateFormat.d();
    var weekday = DateFormat.EEEE();
    var weekdayInThaiLand = weekday.formatInBuddhistCalendarThai(now);
    var dayInThaiLand = day.formatInBuddhistCalendarThai(now);
    var monthInThaiLand = month.formatInBuddhistCalendarThai(now);
    var yearInThaiLand = year.formatInBuddhistCalendarThai(now);
    List<String> intervalDay = [];
    List<String> intervalWeekDay = [];
    for (int x = 0; x <= 7; x++) {
      var tomorrow = DateTime(now.year, now.month, now.day + x);
      var tmrweekday = DateFormat.EEEE();
      var tmrweekdayInThaiLand = weekday.formatInBuddhistCalendarThai(tomorrow);
      var tmrdayInThaiLand = day.formatInBuddhistCalendarThai(tomorrow);
      intervalDay.add(tmrdayInThaiLand);
      intervalWeekDay.add(tmrweekdayInThaiLand);
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedToday = formatter.format(DateTime.now());
    Future<Weather> weather() async {
      WeatherFactory wf =
          new WeatherFactory("f7375b88afe68f4fcd932111fab5e807");
      Weather weather = await wf.currentWeatherByCityName("lamphun");
      return weather;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Wrap(
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
                        0.9,
                      ],
                      colors: [
                        HexColor("#067D68"),
                        HexColor("#1c2b35"),
                      ],
                    )),
                child: Container(
                  height: 0.5.sh,
                  width: 1.sw,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.sw, 0.1.sw, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 0.3.sw,
                          width: 0.3.sw,
                          child: WeatherIcon(cityName: "Lamphun"),
                        ),
                        Text(
                          '${_currentWeather?['temp']}°C',
                          style: GoogleFonts.notoSansThai(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 62.sp),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 0.1.sw,
                                  height: 0.1.sw,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/icons8-cloud-64.png"),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'ปริมาณเมฆ',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp),
                                  ),
                                ),
                                Text(
                                  '${_currentWeather?['clouds']}%',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 0.1.sw,
                                  height: 0.1.sw,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/icons8-weather-64.png"),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'ความเร็วลม',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp),
                                  ),
                                ),
                                Text(
                                  '${_currentWeather?['windSpeed']} km/h',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 0.07.sw,
                                  height: 0.07.sw,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/icons8-water-48.png"),
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 0.02.sw),
                                  child: Text(
                                    'ความชื้น',
                                    style: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${_currentWeather?['humidity']}%',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.sp),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0.05.sw),
                  child: Container(
                      height: 0.3.sw,
                      child: SevenDayForecast(
                          apiKey: "f7375b88afe68f4fcd932111fab5e807",
                          cityName: "Lamphun")),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.08.sw, left: 0.05.sw),
                  child: Text(
                    'กิจกรรมวันนี้',
                    style: GoogleFonts.notoSansThai(
                      textStyle: TextStyle(
                          color: HexColor("#1c2b35"),
                          fontWeight: FontWeight.w800,
                          fontSize: 28.sp),
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: firestoreReference
                        .collection("activityEvents")
                        .where('Farmer', isEqualTo: auth.currentUser?.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final eventscheck = snapshot.data!.docs
                          .map((doc) => doc["detail"])
                          .where((detail) => detail is Map<String, dynamic>)
                          .map((detail) => detail[
                              DateFormat('yyyy-MM-dd').format(DateTime.now())])
                          .where((eventList) => eventList is List<dynamic>)
                          .expand((eventList) => eventList)
                          .toList();

                      if (eventscheck.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(left: 0.06.sw, top: 0.05.sw),
                          child: Container(
                            child: Text(
                              "ไม่พบกิจกรรมสำหรับวันนี้",
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: HexColor("#1c2b35"),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                          height: 0.8.sw,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                                top: 0.04.sw, left: 0.05.sw, right: 0.05.sw),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map<Widget>(
                                (QueryDocumentSnapshot<Map<String, dynamic>>
                                    myEvents) {
                              final events = myEvents["detail"];
                              if (events is Map<String, dynamic>) {
                                final eventlist = events[
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now())];
                                if (eventlist is List<dynamic>) {
                                  return Column(
                                    children: eventlist.map((event) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 0.05.sw),
                                        child: event['status'] == 'waitting'
                                            ? ListTile(
                                                visualDensity: VisualDensity(
                                                    horizontal: 0, vertical: 0),
                                                contentPadding:
                                                    EdgeInsets.all(0),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      /*  Bounceable(
                                                  onTap: () {
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                        title: Text(
                                                          "ลบกิจกรรม",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts
                                                              .notoSansThai(
                                                            textStyle: TextStyle(
                                                                color: HexColor(
                                                                    "#00000"),
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    18.sp),
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "คุณต้องการลบกิจกรรมใช่หรือไม่?",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts
                                                              .notoSansThai(
                                                            textStyle: TextStyle(
                                                                color: HexColor(
                                                                    "#00000"),
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel'),
                                                            child: Text(
                                                              "ยกเลิก",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .notoSansThai(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14.sp),
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              completedEvent(
                                                                  myEvents,
                                                                  event);
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "ตกลง",
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
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                      width: 0.08.sw,
                                                      height: 0.08.sw,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topRight,
                                                            end: Alignment
                                                                .bottomLeft,
                                                            colors: [
                                                              HexColor(
                                                                  "#83D475"),
                                                              HexColor(
                                                                  "#2EB62C"),
                                                            ],
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 0.3,
                                                              blurRadius: 1.3,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: Icon(
                                                        Icons.done,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 0.02.sw,
                                                ), */
                                                      /* Bounceable(
                                                  onTap: () {
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                        title: Text(
                                                          "ลบกิจกรรม",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts
                                                              .notoSansThai(
                                                            textStyle: TextStyle(
                                                                color: HexColor(
                                                                    "#00000"),
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    18.sp),
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "คุณต้องการลบกิจกรรมใช่หรือไม่?",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts
                                                              .notoSansThai(
                                                            textStyle: TextStyle(
                                                                color: HexColor(
                                                                    "#00000"),
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel'),
                                                            child: Text(
                                                              "ยกเลิก",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .notoSansThai(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    letterSpacing:
                                                                        0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14.sp),
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              deleteEvent(
                                                                  myEvents,
                                                                  event);
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "ตกลง",
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
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                      width: 0.08.sw,
                                                      height: 0.08.sw,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 0.3,
                                                              blurRadius: 1.3,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topRight,
                                                            end: Alignment
                                                                .bottomLeft,
                                                            colors: [
                                                              HexColor(
                                                                  "#F1959B"),
                                                              HexColor(
                                                                  "#DC1C13"),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: Icon(
                                                        Ionicons.trash_outline,
                                                        color: Colors.white,
                                                      )),
                                                ), */
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
                                                        decoration:
                                                            BoxDecoration(
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
                                                    ] else if (event[
                                                                'eventTitle']
                                                            .toString() ==
                                                        'พ่นสารเคมี') ...[
                                                      Container(
                                                        width: 0.15.sw,
                                                        height: 0.15.sw,
                                                        decoration:
                                                            BoxDecoration(
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
                                                          Ionicons
                                                              .flask_outline,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ] else if (event[
                                                                'eventTitle']
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
                                                    ] else if (event[
                                                                'eventTitle']
                                                            .toString() ==
                                                        'ตัดแต่งกิ่ง') ...[
                                                      Container(
                                                        width: 0.15.sw,
                                                        height: 0.15.sw,
                                                        decoration:
                                                            BoxDecoration(
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
                                                    ] else if (event[
                                                                'eventTitle']
                                                            .toString() ==
                                                        'เก็บเกี่ยว') ...[
                                                      Container(
                                                        width: 0.15.sw,
                                                        height: 0.15.sw,
                                                        decoration:
                                                            BoxDecoration(
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
                                                          Ionicons
                                                              .basket_outline,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      event['eventTitle']
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .notoSansThai(
                                                        textStyle: TextStyle(
                                                            color: Colors.black,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14.sp),
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
                                                                      10.sp),
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
                                                                        10.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                                title: Padding(
                                                  padding:
                                                      EdgeInsets.all(0.0.sw),
                                                  child: Text(
                                                    event['Farm'].toString(),
                                                    style: GoogleFonts
                                                        .notoSansThai(
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
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            }).toList(),
                          ));
                    }),
              ],
            )
          ],
        ),
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
                                    icon: Icon(Ionicons.home_outline),
                                    color: Colors.white,
                                    padding: EdgeInsets.zero,
                                    iconSize: 0.07.sw,
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(
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
                                    "หน้าหลัก",
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
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                carlendar_page(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
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
     /*  floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#067D68"),
        onPressed: () => setState(() {}),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ), */
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    WeatherFactory wf = new WeatherFactory("f7375b88afe68f4fcd932111fab5e807",
        language: Language.THAI);
    Weather currentWeather = await wf.currentWeatherByCityName('Lamphun');
    double windSpeedInKilometersPerHour = currentWeather.windSpeed! * 3.6;
    return {
      'temp': currentWeather.temperature!.celsius!.toStringAsFixed(0),
      'clouds': currentWeather.cloudiness.toString(),
      'windSpeed': windSpeedInKilometersPerHour.toStringAsFixed(2),
      'humidity': currentWeather.humidity.toString(),
    };
  }

  _getCurrentWeather() async {
    try {
      Map<String, dynamic> currentWeather = await getCurrentWeather();
      setState(() {
        _currentWeather = currentWeather;
      });
    } catch (error) {
      print(error);
    }
  }
}

class WeatherIcon extends StatelessWidget {
  final String cityName;

  WeatherIcon({required this.cityName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: _getWeatherData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          IconData iconData;

          // Determine which icon to use based on the weather condition
          switch (snapshot.data!.weatherMain) {
            case "Clear":
              iconData = Icons.wb_sunny;
              break;
            case "Clouds":
              iconData = Icons.cloud;
              break;
            case "Rain":
              iconData = Icons.beach_access;
              break;
            case "Snow":
              iconData = Icons.ac_unit;
              break;
            case "Thunderstorm":
              iconData = Icons.flash_on;
              break;
            default:
              iconData = Icons.wb_sunny;
              break;
          }

          return Icon(
            iconData,
            size: 50.0,
            color: Colors.white,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }

  Future<Weather> _getWeatherData() async {
    WeatherFactory wf = new WeatherFactory("f7375b88afe68f4fcd932111fab5e807");
    return await wf.currentWeatherByCityName(cityName);
  }
}

class RainPercentage extends StatelessWidget {
  final String cityName;

  RainPercentage({required this.cityName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: _getWeatherData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double? rainVolume = snapshot.data!.rainLastHour;
          if (rainVolume == null) {
            return Text("No rain data available");
          } else {
            double rainPercentage = (rainVolume / 1) * 100;
            return Text(
                "Chance of rain: ${rainPercentage.toStringAsFixed(0)}%");
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }

  Future<Weather> _getWeatherData() async {
    WeatherFactory wf = new WeatherFactory("f7375b88afe68f4fcd932111fab5e807");
    return await wf.currentWeatherByCityName(cityName);
  }
}

class WeatherForecast {
  final String dayOfWeek;
  final String weatherDescription;
  final String temperature;
  final String time;

  WeatherForecast(
      {required this.dayOfWeek,
      required this.weatherDescription,
      required this.temperature,
      required this.time});
}

class SevenDayForecast extends StatefulWidget {
  final String apiKey;
  final String cityName;

  SevenDayForecast({required this.apiKey, required this.cityName});

  @override
  _SevenDayForecastState createState() => _SevenDayForecastState();
}

class _SevenDayForecastState extends State<SevenDayForecast> {
  late WeatherFactory _weatherStation;
  late List<WeatherForecast> _forecastList = [];

  @override
  void initState() {
    super.initState();
    _weatherStation = WeatherFactory(widget.apiKey);
    _fetchSevenDayForecast();
  }

  void _fetchSevenDayForecast() async {
    List<Weather> forecast =
        await _weatherStation.fiveDayForecastByCityName(widget.cityName);
    final today = DateTime.now().weekday;
    setState(() {
      print(forecast);
    _forecastList = forecast
    .where((e) => e.date!.difference(DateTime.now()).inDays < 7)
    .map((e) => WeatherForecast(
        dayOfWeek: _getDayOfWeek(e.date!),
        weatherDescription:
            _weatherDescriptions[e.weatherMain!] ?? e.weatherMain!,
        temperature: '${e.temperature!.celsius!.toStringAsFixed(0)}°C',
        time: '${_getTimeOfDay(e.date!)}'))
    .toList();
    });
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'จันทร์';
      case DateTime.tuesday:
        return 'อังคาร';
      case DateTime.wednesday:
        return 'พุธ';
      case DateTime.thursday:
        return 'พฤหัสบดี';
      case DateTime.friday:
        return 'ศุกร์';
      case DateTime.saturday:
        return 'วันเสาร์';
      case DateTime.sunday:
        return 'วันอาทิตย์';
      default:
        return '';
    }
  }

  static const Map<String, String> _weatherDescriptions = {
    'Clear': 'แจ่มใส',
    'Clouds': 'มีเมฆ',
    'Rain': 'ฝนตก',
    // add more translations here
  };

  String _getTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return _forecastList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: 0.5.sw,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _forecastList.length,
                itemBuilder: (context, index) {
                  print(_forecastList.length);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
                    child: Container(
                      width: 0.25.sw,
                      height: 0.25.sw,
                      decoration: BoxDecoration(
                        gradient: (() {
      if (_forecastList[index].weatherDescription == 'แจ่มใส') {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HexColor("#f9c487"),
           HexColor("#00a4ff"),
          ],
        );
      } else if (_forecastList[index].weatherDescription == 'มีเมฆ') {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor("#00314f"),
           HexColor("#3ed0ff"),
          ],
        );
      } else if (_forecastList[index].weatherDescription == 'ฝนตก') {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor("#000000"),
           HexColor("#09536b"),
          ],
        );
      } else {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor("#067D68"),
            HexColor("#1c2b35"),
          ],
        );
      }
    }()),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0.025.sw),
                        child: Column(
                          children: [
                            Text(
                              _forecastList[index].time,
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp),
                              ),
                            ),
                            Text(
                              _forecastList[index].dayOfWeek,
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp),
                              ),
                            ),
                            Text(
                              _forecastList[index].temperature,
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp),
                              ),
                            ),
                            Text(
                              _forecastList[index].weatherDescription,
                              style: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}

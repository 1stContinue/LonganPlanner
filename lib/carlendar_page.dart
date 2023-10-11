import 'dart:async';
import 'package:app_project/farm_page.dart';
import 'package:app_project/home_page.dart';
import 'package:app_project/main.dart';
import 'package:app_project/user_menu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

final firestoreReference = FirebaseFirestore.instance;
StreamSubscription<QuerySnapshot<Object?>>? _streamSubscription = null;
final FirebaseAuth auth = FirebaseAuth.instance;

var dateactivity = TextEditingController();
var Notecontroller = TextEditingController();
TextEditingController _savedNote = TextEditingController();

class CarlendarPage extends StatelessWidget {
  const CarlendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          home: carlendar_page(),
        );
      },
    );
  }
}

class carlendar_page extends StatefulWidget {
  const carlendar_page({super.key});

  @override
  State<carlendar_page> createState() => _carlendar_pageState();
}

class _carlendar_pageState extends State<carlendar_page> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  Map<String, dynamic> getEventOnDB = {};
  Map<String, dynamic> checkEvents = {};
  Map<String, List> myselectedEvents = {};
  bool isChecked = false;
  var waterDuration = 5;
  var chemiDuration = 7;
  var getchemDuration = 0;
  var getwaterDuration = 0;
  var getFarmvalue;
  var getNotevalue;
  var getEventTitle;
  var getDate;
  DateTime? getDatestartTask;
  Map<String, List<Map<String, dynamic>>>? tasks;
  List<dynamic> _listOfDayEvents(DateTime dateTime) {
    final events = getEventOnDB[DateFormat('yyy-MM-dd').format(dateTime)];
    if (events != null) {
      final filteredEvents =
          events.where((event) => event['status'] == 'waitting');
      return filteredEvents.toList();
    } else {
      return [];
    }
  }

  @override
  void initState() {
    _selectedDate = _focusedDay;
    // TODO: implement initState
    super.initState();
    getEventOnDB.clear();
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: HexColor("#f0ecec"),
      body: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
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
              child: Column(
                children: [
                  Container(
                    height: 0.55.sh,
                    width: 1.sw,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('activityEvents')
                                .where('Farmer', isEqualTo: userData?.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.hasData) {
                                snapshot.data?.docs.map(
                                    (QueryDocumentSnapshot<Map<String, dynamic>>
                                        myEvents) {
                                  final getev = myEvents["detail"];
                                  return getEventOnDB.addAll(getev);
                                }).toList();
                              }
                              return TableCalendar(
                                eventLoader: _listOfDayEvents,
                                calendarFormat: _calendarFormat,
                                firstDay: DateTime(2023),
                                lastDay: DateTime(2030),
                                focusedDay: _focusedDay,
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#FFFFFF"),
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 19.sp),
                                  ),
                                  leftChevronIcon: Icon(
                                    Ionicons.arrow_back_circle,
                                    color: Colors.white,
                                  ),
                                  rightChevronIcon: Icon(
                                    Ionicons.arrow_forward_circle,
                                    color: Colors.white,
                                  ),
                                ),
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, day, events) =>
                                      events.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                width: 0.03.sw,
                                                height: 0.03.sw,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            )
                                          : null,
                                ),
                                daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#FFFFFF"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp),
                                    ),
                                    weekendStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#FFFFFF"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp),
                                    )),
                                calendarStyle: CalendarStyle(
                                    defaultTextStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#FFFFFF"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                    outsideTextStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: Colors.white38,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                    holidayTextStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#FFFFFF"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                    weekendTextStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#FFFFFF"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                    todayTextStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#067D68"),
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12.sp),
                                    ),
                                    todayDecoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle)),
                                onDaySelected: ((selectedDay, focusedDay) {
                                  if (!isSameDay(_selectedDate, selectedDay)) {
                                    setState(() {
                                      _selectedDate = selectedDay;
                                      _focusedDay = focusedDay;
                                    });
                                  }
                                }),
                                selectedDayPredicate: ((day) {
                                  return isSameDay(_selectedDate, day);
                                }),
                                onFormatChanged: (format) {
                                  if (_calendarFormat != format) {
                                    setState(() {
                                      _calendarFormat = format;
                                    });
                                  }
                                },
                                onPageChanged: (focusedDay) {
                                  _focusedDay = focusedDay;
                                },
                              );
                            })
                      ],
                    ),
                  ),
                ],
              )),
          StreamBuilder(
              stream: firestoreReference
                  .collection("activityEvents")
                  .where('Farmer',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
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
                              DateFormat('yyyy-MM-dd').format(_selectedDate!)];
                          if (eventlist is List<dynamic>) {
                            return Column(
                              children: eventlist
                                  .where(
                                      (event) => event['status'] == 'waitting')
                                  .map((event) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 0.05.sw),
                                  child: event['status'] == 'waitting'
                                      ? ListTile(
                                          visualDensity: VisualDensity(
                                              horizontal: 0, vertical: 0),
                                          contentPadding: EdgeInsets.all(0),
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
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Bounceable(
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
                                                          "บันทึกกิจกรรม",
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
                                                        content: Container(
                                                          height: 0.6.sw,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "คุณต้องการบันทึกกิจกรรมนี้ใช่หรือไม่?",
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
                                                                              .w300,
                                                                      fontSize:
                                                                          14.sp),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 0.45.sw,
                                                                child:
                                                                    TextFormField(
                                                                  maxLines: 8,
                                                                  controller:
                                                                      _savedNote,
                                                                  cursorColor:
                                                                      HexColor(
                                                                          "#067D68"),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        HexColor(
                                                                            "#D9D9D9"),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none,
                                                                    ),
                                                                    hintText:
                                                                        'บันทึกช่วยจำกิจกรรมของคุณ',
                                                                    hintStyle:
                                                                        GoogleFonts
                                                                            .notoSansThai(
                                                                      textStyle: TextStyle(
                                                                          color: Colors.grey[
                                                                              700],
                                                                          letterSpacing:
                                                                              .25,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              14.sp),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              _savedNote
                                                                  .clear();
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel');
                                                            },
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
                                                              _savedNote
                                                                  .clear();
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
                                                ),
                                                Bounceable(
                                                  onTap: () {
                                                    print(getEventOnDB[
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                _selectedDate!)]);
                                                    getvalueEvent(
                                                        myEvents, event);
                                                    slideDialog.showSlideDialog(
                                                        context: context,
                                                        child: Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            child: Container(
                                                              height: 0.9.sh,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      gradient:
                                                                          LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                stops: [
                                                                  0.4,
                                                                  0.9,
                                                                  1
                                                                ],
                                                                colors: [
                                                                  HexColor(
                                                                      "#FFFFF"),
                                                                  HexColor(
                                                                      "#02322a"),
                                                                  HexColor(
                                                                      "#010c0a"),
                                                                ],
                                                              )),
                                                              child: Center(
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'แก้ไขกิจกรรมสวน',
                                                                          style:
                                                                              GoogleFonts.notoSansThai(
                                                                            textStyle: TextStyle(
                                                                                color: HexColor("#2F4858"),
                                                                                letterSpacing: .25,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 28.sp),
                                                                          )),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 0.04.sw),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              0.75.sw,
                                                                          child:
                                                                              DropdownButtonFormField<String>(
                                                                            decoration: InputDecoration(
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    const Radius.circular(13),
                                                                                  ),
                                                                                ),
                                                                                filled: true,
                                                                                hintStyle: GoogleFonts.notoSansThai(
                                                                                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 16.sp),
                                                                                ),
                                                                                hintText: getEventTitle,
                                                                                fillColor: Colors.white),
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            value:
                                                                                getEventTitle!,
                                                                            isExpanded:
                                                                                true,
                                                                            isDense:
                                                                                true,
                                                                            menuMaxHeight:
                                                                                0.5.sw,
                                                                            items: [
                                                                              DropdownMenuItem(child: Text("ให้น้ำ"), value: "ให้น้ำ"),
                                                                              DropdownMenuItem(
                                                                                child: Text("ตัดแต่งกิ่ง"),
                                                                                value: "ตัดแต่งกิ่ง",
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                child: Text("พ่นสารเคมี"),
                                                                                value: "พ่นสารเคมี",
                                                                              ),
                                                                              /* DropdownMenuItem(
                                      child: Text("ใส่ปุ๋ย"),
                                      value: "ใส่ปุ๋ย",
                                    ), */
                                                                              DropdownMenuItem(
                                                                                child: Text("เก็บเกี่ยว"),
                                                                                value: "เก็บเกี่ยว",
                                                                              )
                                                                            ],
                                                                            onChanged:
                                                                                (activityvalue) {
                                                                              setState(() {
                                                                                getEventTitle = activityvalue.toString();
                                                                                print(getEventTitle);
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      StreamBuilder(
                                                                        stream: firestoreReference
                                                                            .collection(
                                                                                "Farm")
                                                                            .where('Farmer',
                                                                                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                                                            .snapshots(),
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot
                                                                                snapshot) {
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return Center(
                                                                              child: CircularProgressIndicator(),
                                                                            );
                                                                          }
                                                                          return Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 0.04.sw),
                                                                            child:
                                                                                SizedBox(
                                                                              width: 0.75.sw,
                                                                              child: DropdownButtonFormField<String>(
                                                                                decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(
                                                                                      borderRadius: const BorderRadius.all(
                                                                                        const Radius.circular(13),
                                                                                      ),
                                                                                    ),
                                                                                    filled: true,
                                                                                    hintStyle: GoogleFonts.notoSansThai(
                                                                                      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 16.sp),
                                                                                    ),
                                                                                    hintText: getFarmvalue,
                                                                                    fillColor: Colors.white),
                                                                                borderRadius: BorderRadius.circular(20),
                                                                                value: getFarmvalue!,
                                                                                isExpanded: true,
                                                                                isDense: true,
                                                                                menuMaxHeight: 0.5.sw,
                                                                                items: snapshot.data.docs.map<DropdownMenuItem<String>>((document) {
                                                                                  return new DropdownMenuItem<String>(child: Text(document["FarmName"]), value: document["FarmName"]);
                                                                                }).toList(),
                                                                                onChanged: (activityFarmvalue) {
                                                                                  setState(() {
                                                                                    getFarmvalue = activityFarmvalue.toString();
                                                                                    print(selectedFarm);
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      /* Padding(
                        padding: EdgeInsets.only(top: 0.04.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          child: TextFormField(
                            controller: dateactivity,
                            onTap: () async {
                              /// Current locale is TH.
                              DateTime? newDateTime =
                                  await showRoundedDatePicker(
                                height: 0.75.sw,
                                firstDate: DateTime(DateTime.now().year - 5),
                                lastDate: DateTime(DateTime.now().year + 5),
                                context: context,
                                locale: Locale("th", "TH"),
                                era: EraMode.CHRIST_YEAR,
                              );
                              if (newDateTime != null) {
                                print("เพิ่มกิจกรรมแล้ว");
                                getActivityDate = newDateTime;
                                setState(() {
                                  dateactivity.text = DateFormat.yMMMMd()
                                      .format(newDateTime)
                                      .toString();
                                  print(getActivityDate);
                                });
                              }
                            },
                            readOnly: true,
                            cursorColor: HexColor("#067D68"),
                            decoration: InputDecoration(
                                suffixIcon: Icon(Ionicons.calendar_outline),
                                iconColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: HexColor("#FFFFFF"),
                                hintText: getDate,
                                hintStyle: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16.sp))),
                          ),
                        ),
                      ), */
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 0.055.sw),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              0.75.sw,
                                                                          child:
                                                                              TextFormField(
                                                                            maxLines:
                                                                                4,
                                                                            controller:
                                                                                Notecontroller,
                                                                            cursorColor:
                                                                                HexColor("#067D68"),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              filled: true,
                                                                              fillColor: HexColor("#FFFFFF"),
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                borderSide: BorderSide(
                                                                                  color: Colors.black,
                                                                                  width: 1.4,
                                                                                ),
                                                                              ),
                                                                              hintText: getNotevalue != "" ? getNotevalue : "บันทึกสำหรับกิจกรรมนี้",
                                                                              hintStyle: GoogleFonts.notoSansThai(
                                                                                textStyle: TextStyle(color: getNotevalue != "" ? Colors.black : Colors.grey, fontWeight: FontWeight.w300, fontSize: 16.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 0.055.sw),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              0.75.sw,
                                                                          height:
                                                                              0.05.sh,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: HexColor("#067D68"),
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                elevation: 3),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {});
                                                                              if (getEventTitle == null) {
                                                                                Fluttertoast.showToast(msg: "กรุณาเลือกประเภทกิจกรรม", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 10.sp);
                                                                              } else if (getFarmvalue == null) {
                                                                                Fluttertoast.showToast(msg: "กรุณาเลือกสวน", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 10.sp);
                                                                              }
                                                                              editEvent(myEvents, event);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'ยืนยัน',
                                                                              style: GoogleFonts.notoSansThai(
                                                                                textStyle: TextStyle(color: HexColor("#FFFFFF"), letterSpacing: .25, fontWeight: FontWeight.w500, fontSize: 18.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ]),
                                                              ),
                                                            ),
                                                          ),
                                                        ));
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
                                                                  "#FFD400"),
                                                              HexColor(
                                                                  "#FF6200"),
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
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 0.02.sw,
                                                ),
                                                Bounceable(
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
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          HexColor("#00BFFF"),
                                                          HexColor("#000080"),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          HexColor("#800080"),
                                                          HexColor("#1d1160"),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                          BorderRadius.circular(
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
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          HexColor("#b6773b"),
                                                          HexColor("#673400"),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          HexColor("#FEBE10"),
                                                          HexColor("#B5651D"),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Icon(
                                                    Ionicons.basket_outline,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ] else if (event['eventTitle']
                                                      .toString() ==
                                                  'ราดสารเคมี') ...[
                                                Container(
                                                  width: 0.15.sw,
                                                  height: 0.15.sw,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          HexColor("#800080"),
                                                          HexColor("#1d1160"),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Icon(
                                                    Ionicons.flask_outline,
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
                                                event['eventTitle'].toString(),
                                                style: GoogleFonts.notoSansThai(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.sp),
                                                ),
                                              ),
                                              if (event['Note'].toString() !=
                                                  "") ...[
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        'หมายเหตุ: ' +
                                                            event['Note']
                                                                .toString(),
                                                        style: GoogleFonts
                                                            .notoSansThai(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 10.sp),
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
                                              event['Farm'].toString(),
                                              style: GoogleFonts.notoSansThai(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w800,
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
/*                               decoration: BoxDecoration(
                                color: HexColor("#067D68"),
                                borderRadius: BorderRadius.circular(5)), */
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
                      FadeIn(
                        child: Padding(
                            padding: EdgeInsets.only(right: 0.sw),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: HexColor("#067D68"),
                                  borderRadius: BorderRadius.circular(5)),
                              width: 0.12.sw,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                    constraints: BoxConstraints(),
                                    icon:
                                        Icon(Ionicons.calendar_number_outline),
                                    color: HexColor("#FFFFFF"),
                                    padding: EdgeInsets.zero,
                                    iconSize: 0.07.sw,
                                    onPressed: () {},
                                  ),
                                  Text(
                                    "ปฏิทิน",
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
                            )),
                      ),
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
                                              print(_streamSubscription);
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#067D68"),
        onPressed: () async {
          final collection = FirebaseFirestore.instance
              .collection('Farm')
              .where('Farmer',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid);
          final querySnapshot = await collection.get();
          if (querySnapshot.docs.isEmpty) {
            // Show dialog if collection is empty
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                title: Text(
                  "ไม่พบสวน",
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
                  "คุณยังไม่มีสวนกรุณาเพิ่มสวนของคุณก่อน",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.notoSansThai(
                    textStyle: TextStyle(
                        color: HexColor("#00000"),
                        letterSpacing: 0,
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp),
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
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

          setState(() {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                title: Text(
                  "เพิ่มกิจกรรม",
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
                  "คุณสามารถเพิ่มกิจกรรมทั้งหมดได้ในทันที และสามารถเลือกเพิ่มทีละกิจกรรมได้",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.notoSansThai(
                    textStyle: TextStyle(
                        color: HexColor("#00000"),
                        letterSpacing: 0,
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp),
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'เพิ่มกิจกรรมทั้งหมด');
                      _calculateDialog();
                    },
                    child: Text(
                      "เพิ่มกิจกรรมทั้งหมด",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.notoSansThai(
                        textStyle: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'เพิ่มทีละกิจกรรม');
                      _addActivityDialog();
                    },
                    child: Text(
                      "เพิ่มทีละกิจกรรม",
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
          });
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String? selectedActivityValue;
  String? selectedFarm;
  var getActivityDate;

  void _calculateDialog() {
    dateactivity.clear();
    slideDialog.showSlideDialog(
        context: context,
        child: StatefulBuilder(builder: (context, setState) {
          return Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: 0.8.sh,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.52, 0.9, 1],
                  colors: [
                    HexColor("#FFFFF"),
                    HexColor("#02322a"),
                    HexColor("#010c0a"),
                  ],
                )),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('เพิ่มกิจกรรมทั้งหมด',
                          style: GoogleFonts.notoSansThai(
                            textStyle: TextStyle(
                                color: HexColor("#2F4858"),
                                letterSpacing: .25,
                                fontWeight: FontWeight.w600,
                                fontSize: 28.sp),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.04.sw, left: 0.15.sw, right: 0.15.sw),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.04.sw),
                              child: SizedBox(
                                width: 0.75.sw,
                                child: TextFormField(
                                  controller: dateactivity,
                                  onTap: () async {
                                    /// Current locale is TH.
                                    DateTime? newDateStartTask =
                                        await showRoundedDatePicker(
                                      height: 0.75.sw,
                                      firstDate:
                                          DateTime(DateTime.now().year - 5),
                                      lastDate:
                                          DateTime(DateTime.now().year + 5),
                                      context: context,
                                      locale: Locale("th", "TH"),
                                      era: EraMode.CHRIST_YEAR,
                                    );
                                    if (newDateStartTask != null) {
                                      setState(() {
                                        getActivityDate = newDateStartTask;
                                        dateactivity.text = DateFormat.yMMMMd()
                                            .format(newDateStartTask)
                                            .toString();
                                      });
                                    }
                                  },
                                  readOnly: true,
                                  cursorColor: HexColor("#067D68"),
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Ionicons.calendar_outline),
                                    iconColor: Colors.black,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    filled: true,
                                    fillColor: HexColor("#FFFFFF"),
                                    hintText: 'เลือกวันที่เริ่มตัดแต่งกิ่ง',
                                    hintStyle: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: Colors.grey,
                                          letterSpacing: .25,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: firestoreReference
                                  .collection("Farm")
                                  .where('Farmer',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser?.uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.04.sw),
                                  child: SizedBox(
                                    width: 0.75.sw,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(13),
                                            ),
                                          ),
                                          filled: true,
                                          hintStyle: GoogleFonts.notoSansThai(
                                            textStyle: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 16.sp),
                                          ),
                                          hintText: "กรุณาเลือกสวน",
                                          fillColor: Colors.white),
                                      borderRadius: BorderRadius.circular(20),
                                      value: selectedFarm,
                                      isExpanded: true,
                                      isDense: true,
                                      menuMaxHeight: 0.5.sw,
                                      items: snapshot.data.docs
                                          .map<DropdownMenuItem<String>>(
                                              (document) {
                                        return new DropdownMenuItem<String>(
                                            child: Text(document["FarmName"]),
                                            value: document["FarmName"]);
                                      }).toList(),
                                      onChanged: (activityFarmvalue) {
                                        setState(() {
                                          selectedFarm =
                                              activityFarmvalue.toString();
                                          print(selectedFarm);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.04.sw),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ระยะการให้น้ำ",
                                    style: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#00000"),
                                          letterSpacing: .25,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.02.sw,
                                  ),
                                  SizedBox(
                                      width: 0.3.sw,
                                      height: 0.06.sh,
                                      child: isChecked
                                          ? SpinBox(
                                              textStyle:
                                                  TextStyle(fontSize: 14.sp),
                                              iconSize: 0.05.sw,
                                              decimals: 0,
                                              step: 1,
                                              min: 5,
                                              max: 7,
                                              value: waterDuration.toDouble(),
                                              onChanged: (size) => setState(() {
                                                waterDuration = size.toInt();
                                                print(waterDuration);
                                              }),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.all(0.03.sw),
                                              child: Text(
                                                "$waterDuration",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.notoSansThai(
                                                  textStyle: TextStyle(
                                                      color: HexColor("#00000"),
                                                      letterSpacing: .25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.sp),
                                                ),
                                              ),
                                            )),
                                  Text(
                                    "วัน",
                                    style: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#00000"),
                                          letterSpacing: .25,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0.04.sw,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 0.03.sw),
                                  child: Text(
                                    "ระยะการพ่นสาร",
                                    style: GoogleFonts.notoSansThai(
                                      textStyle: TextStyle(
                                          color: HexColor("#00000"),
                                          letterSpacing: .25,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 0.3.sw,
                                    height: 0.06.sh,
                                    child: isChecked
                                        ? SpinBox(
                                            textStyle:
                                                TextStyle(fontSize: 14.sp),
                                            iconSize: 0.05.sw,
                                            decimals: 0,
                                            step: 1,
                                            min: 5,
                                            max: 7,
                                            value: chemiDuration.toDouble(),
                                            onChanged: (size) => setState(() {
                                              chemiDuration = size.toInt();
                                            }),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.all(0.03.sw),
                                            child: Text(
                                              "$chemiDuration",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.notoSansThai(
                                                textStyle: TextStyle(
                                                    color: HexColor("#00000"),
                                                    letterSpacing: .25,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          )),
                                Text(
                                  "วัน",
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#00000"),
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.04.sw,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Text(
                                  "ปรับแต่งระยะเวลากิจกรรม",
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#00000"),
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.055.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.05.sh,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#067D68"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 3),
                            onPressed: () async {
                              tasks = addTasks();
                              CollectionReference activityEventsRef =
                                  FirebaseFirestore.instance
                                      .collection('activityEvents');
                              tasks?.forEach(
                                (key, value) {
                                  Timestamp timestamp =
                                      Timestamp.fromDate(DateTime.parse(key));
                                  Query query = activityEventsRef
                                      .where('detail.$key', isEqualTo: null);
                                  Query query2 = activityEventsRef
                                      .where('detail.$key', isNotEqualTo: null);
                                  query2.get().then((querySnapshot2) {
                                    activityEventsRef.add({
                                      'Farmer': userData?.uid,
                                      'detail': {key: tasks?[key]},
                                      'date': timestamp,
                                    });
                                  });
                                  query.get().then((querySnapshot) {
                                    // loop through the query results to find the correct document
                                    for (DocumentSnapshot docSnapshot
                                        in querySnapshot.docs) {
                                      Map<String, dynamic>? data = docSnapshot
                                          .data() as Map<String, dynamic>;
                                      if (data != null &&
                                          data['detail'] != null) {
                                        Map<String, dynamic> detail =
                                            data['detail'];
                                        if (detail.containsKey(key)) {
                                          // update the document with the new event data
                                          docSnapshot.reference.update({
                                            'detail.$key':
                                                FieldValue.arrayUnion([
                                              {
                                                'eventTitle':
                                                    selectedActivityValue,
                                                'Farm': selectedFarm
                                              }
                                            ])
                                          }).then((value) {
                                            print('Event added successfully');
                                            myselectedEvents.clear();
                                          }).catchError((error) => print(
                                              'Failed to add event: $error'));
                                          break;
                                        }
                                      }
                                    }
                                  });
                                },
                              );
                              print(tasks);
                              print(tasks!.length);
                              Navigator.pop(context);
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
        }));
  }

  void _addActivityDialog() {
    dateactivity.clear();
    Notecontroller.clear();
    slideDialog.showSlideDialog(
        context: context,
        child: Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: 0.9.sh,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.4, 0.9, 1],
                colors: [
                  HexColor("#FFFFF"),
                  HexColor("#02322a"),
                  HexColor("#010c0a"),
                ],
              )),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('เพิ่มกิจกรรมสวน',
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
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(13),
                                ),
                              ),
                              filled: true,
                              hintStyle: GoogleFonts.notoSansThai(
                                textStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.sp),
                              ),
                              hintText: "กรุณาเลือกประเภทกิจกรรม",
                              fillColor: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          value: selectedActivityValue,
                          isExpanded: true,
                          isDense: true,
                          menuMaxHeight: 0.5.sw,
                          items: [
                            DropdownMenuItem(
                                child: Text("ให้น้ำ"), value: "ให้น้ำ"),
                            DropdownMenuItem(
                              child: Text("ตัดแต่งกิ่ง"),
                              value: "ตัดแต่งกิ่ง",
                            ),
                            DropdownMenuItem(
                              child: Text("พ่นสารเคมี"),
                              value: "พ่นสารเคมี",
                            ),
                            /* DropdownMenuItem(
                              child: Text("ใส่ปุ๋ย"),
                              value: "ใส่ปุ๋ย",
                            ), */
                            DropdownMenuItem(
                              child: Text("เก็บเกี่ยว"),
                              value: "เก็บเกี่ยว",
                            )
                          ],
                          onChanged: (activityvalue) {
                            setState(() {
                              selectedActivityValue = activityvalue.toString();
                              print(selectedActivityValue);
                            });
                          },
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: firestoreReference
                          .collection("Farm")
                          .where('Farmer',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 0.04.sw),
                          child: SizedBox(
                            width: 0.75.sw,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(13),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16.sp),
                                  ),
                                  hintText: "กรุณาเลือกสวน",
                                  fillColor: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              value: selectedFarm,
                              isExpanded: true,
                              isDense: true,
                              menuMaxHeight: 0.5.sw,
                              items: snapshot.data.docs
                                  .map<DropdownMenuItem<String>>((document) {
                                return new DropdownMenuItem<String>(
                                    child: Text(document["FarmName"]),
                                    value: document["FarmName"]);
                              }).toList(),
                              onChanged: (activityFarmvalue) {
                                setState(() {
                                  selectedFarm = activityFarmvalue.toString();
                                  print(selectedFarm);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.04.sw),
                      child: SizedBox(
                        width: 0.75.sw,
                        child: TextFormField(
                          controller: dateactivity,
                          onTap: () async {
                            /// Current locale is TH.
                            DateTime? newDateTime = await showRoundedDatePicker(
                              height: 0.75.sw,
                              firstDate: DateTime(DateTime.now().year - 5),
                              lastDate: DateTime(DateTime.now().year + 5),
                              context: context,
                              locale: Locale("th", "TH"),
                              era: EraMode.CHRIST_YEAR,
                            );
                            if (newDateTime != null) {
                              print("เพิ่มกิจกรรมแล้ว");
                              getActivityDate = newDateTime;
                              setState(() {
                                dateactivity.text = DateFormat.yMMMMd()
                                    .format(newDateTime)
                                    .toString();
                                print(getActivityDate);
                              });
                            }
                          },
                          readOnly: true,
                          cursorColor: HexColor("#067D68"),
                          decoration: InputDecoration(
                              suffixIcon: Icon(Ionicons.calendar_outline),
                              iconColor: Colors.black,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: HexColor("#FFFFFF"),
                              hintText: 'เลือกวัน',
                              hintStyle: GoogleFonts.notoSansThai(
                                  textStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16.sp))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.055.sw),
                      child: Container(
                        width: 0.75.sw,
                        child: TextFormField(
                          maxLines: 4,
                          controller: Notecontroller,
                          cursorColor: HexColor("#067D68"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("#FFFFFF"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.4,
                              ),
                            ),
                            hintText: 'บันทึกสำหรับกิจกรรมนี้',
                            hintStyle: GoogleFonts.notoSansThai(
                              textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.055.sw),
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
                            setState(() {});
                            if (selectedActivityValue == null) {
                              Fluttertoast.showToast(
                                  msg: "กรุณาเลือกประเภทกิจกรรม",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 10.sp);
                            } else if (selectedFarm == null) {
                              Fluttertoast.showToast(
                                  msg: "กรุณาเลือกสวน",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 10.sp);
                            } else if (getActivityDate == null) {
                              Fluttertoast.showToast(
                                  msg: "กรุณาเลือกวันที่",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 10.sp);
                            } else if (getActivityDate
                                .isBefore(DateTime.now())) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  title: Text(
                                    "กิจกรรมนี้ถูกดำเนินการไปแล้วใช่หรือไม่",
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
                                    "หากคุณยืนยันกิจกรรมนี้จะถูกย้ายไปที่หน้าประวัติกิจกรรม",
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
                                      onPressed: () {
                                        Navigator.pop(context, 'ยกเลิก');
                                      },
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
                                      onPressed: () {
                                        if (myselectedEvents[
                                                DateFormat('yyy-MM-dd').format(
                                                    getActivityDate!)] !=
                                            null) {
                                          myselectedEvents[
                                                  DateFormat('yyy-MM-dd')
                                                      .format(getActivityDate!)]
                                              ?.add({
                                            "eventTitle": selectedActivityValue,
                                            "Farm": selectedFarm,
                                            "Note": Notecontroller.text.trim(),
                                            "status": "completed",
                                          });
                                        } else {
                                          myselectedEvents[
                                              DateFormat('yyy-MM-dd')
                                                  .format(getActivityDate!)] = [
                                            {
                                              "eventTitle":
                                                  selectedActivityValue,
                                              "Farm": selectedFarm,
                                              "Note":
                                                  Notecontroller.text.trim(),
                                              "status": "completed",
                                            }
                                          ];
                                        }
                                        Firebase.initializeApp()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection('activityEvents')
                                              .add({
                                            'Farmer': userData?.uid,
                                            'detail': myselectedEvents,
                                            'date': getActivityDate,
                                          });
                                          print("เพิ่มในฐานข้อมูลแล้ว");
                                          myselectedEvents.clear();
                                        });
                                        Navigator.pop(context, 'ยืนยัน');
                                        Navigator.pop(context);
                                        //เพิ่มกิจกรรมที่ผ่านไปแล้ว
                                      },
                                      child: Text(
                                        "ยืนยัน",
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
                            } else {
                              if (myselectedEvents[DateFormat('yyy-MM-dd')
                                      .format(getActivityDate!)] !=
                                  null) {
                                myselectedEvents[DateFormat('yyy-MM-dd')
                                        .format(getActivityDate!)]
                                    ?.add({
                                  "eventTitle": selectedActivityValue,
                                  "Farm": selectedFarm,
                                  "Note": Notecontroller.text.trim(),
                                  "status": "waitting",
                                });
                              } else {
                                myselectedEvents[DateFormat('yyy-MM-dd')
                                    .format(getActivityDate!)] = [
                                  {
                                    "eventTitle": selectedActivityValue,
                                    "Farm": selectedFarm,
                                    "Note": Notecontroller.text.trim(),
                                    "status": "waitting",
                                  }
                                ];
                              }
                              if (getEventOnDB[DateFormat('yyy-MM-dd')
                                      .format(getActivityDate!)] !=
                                  null) {
                                print("มีกิจกรรมแล้ว");
                                filterAndUpdate();
                              } else if ((getEventOnDB[DateFormat('yyy-MM-dd')
                                      .format(getActivityDate!)] ==
                                  null)) {
                                _addActivityevents();
                              }
                              dateactivity.clear();

                              Navigator.pop(context);
                              return;
                            }
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future _addActivityevents() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance.collection('activityEvents').add({
        'Farmer': userData?.uid,
        'detail': myselectedEvents,
        'date': getActivityDate,
      });
      print("เพิ่มในฐานข้อมูลแล้ว");
      myselectedEvents.clear();
    });
  }

  void filterAndUpdate() {
    // get a reference to the 'activityEvents' collection
    CollectionReference activityEventsRef =
        FirebaseFirestore.instance.collection('activityEvents');

    // query for documents where 'detail' contains the desired index
    final formattedSelectedDate =
        DateFormat('yyyy-MM-dd').format(getActivityDate).toString();
    Query query = activityEventsRef
        .where('detail.$formattedSelectedDate', isNotEqualTo: null)
        .where('Farmer', isEqualTo: FirebaseAuth.instance.currentUser?.uid);

    query.get().then((querySnapshot) {
      // loop through the query results to find the correct document
      for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>;
        if (data != null && data['detail'] != null) {
          Map<String, dynamic> detail = data['detail'];
          if (detail.containsKey(formattedSelectedDate)) {
            // update the document with the new event data
            docSnapshot.reference.update({
              'detail.$formattedSelectedDate': FieldValue.arrayUnion([
                {
                  'eventTitle': selectedActivityValue,
                  'Farm': selectedFarm,
                  'Note': Notecontroller.text.trim(),
                  'status': 'waitting',
                }
              ])
            }).then((value) {
              print('upDated');
              print('Event added successfully');
              myselectedEvents.clear();
            }).catchError((error) => print('Failed to add event: $error'));
            break;
          }
        }
      }
    });
  }

  void getvalueEvent(
      DocumentSnapshot<Map<String, dynamic>> myEvents, dynamic event) {
    final events = myEvents["detail"];
    if (events is Map<String, dynamic>) {
      final eventList = events[DateFormat('yyyy-MM-dd').format(_selectedDate!)];
      final getdblist =
          getEventOnDB[DateFormat('yyyy-MM-dd').format(_selectedDate!)];

      if (eventList is List<dynamic>) {
        var updateIndex;
        eventList.asMap().forEach((index, getindex) {
          if (getindex.toString() == event.toString()) {
            updateIndex = index;
          }
        });

        if (updateIndex != null) {
          // Update the event status to "completed"
          getFarmvalue = eventList[updateIndex]["Farm"];
          getNotevalue = eventList[updateIndex]["Note"];
          getEventTitle = eventList[updateIndex]["eventTitle"];
          getDate = DateFormat.yMMMMd().format(_selectedDate!);
          // Update the "detail" field of the document with the updated event list
        }
      }
    }
  }

  void editEvent(
      DocumentSnapshot<Map<String, dynamic>> myEvents, dynamic event) {
    final events = myEvents["detail"];
    if (events is Map<String, dynamic>) {
      final eventList = events[DateFormat('yyyy-MM-dd').format(_selectedDate!)];
      final getdblist =
          getEventOnDB[DateFormat('yyyy-MM-dd').format(_selectedDate!)];

      if (eventList is List<dynamic>) {
        var updateIndex;
        eventList.asMap().forEach((index, getindex) {
          if (getindex.toString() == event.toString()) {
            updateIndex = index;
          }
        });

        if (updateIndex != null) {
          // Update the event status to "completed"
          eventList[updateIndex]["Farm"] = getFarmvalue;
          eventList[updateIndex]["eventTitle"] = getEventTitle;
          eventList[updateIndex]["Note"] = Notecontroller.text.trim();
          // Update the "detail" field of the document with the updated event list
          final updatedEvents = {
            DateFormat('yyyy-MM-dd').format(_selectedDate!): eventList
          };
          myEvents.reference.update({"detail": updatedEvents});
        }
      }
    }
  }

  void completedEvent(
      DocumentSnapshot<Map<String, dynamic>> myEvents, dynamic event) {
    final events = myEvents["detail"];
    if (events is Map<String, dynamic>) {
      final eventList = events[DateFormat('yyyy-MM-dd').format(_selectedDate!)];
      final getdblist =
          getEventOnDB[DateFormat('yyyy-MM-dd').format(_selectedDate!)];

      if (eventList is List<dynamic>) {
        var updateIndex;
        eventList.asMap().forEach((index, getindex) {
          if (getindex.toString() == event.toString()) {
            updateIndex = index;
          }
        });

        if (updateIndex != null) {
          // Update the event status to "completed"
          eventList[updateIndex]["status"] = "completed";
          eventList[updateIndex]["Note"] = _savedNote.text.trim();
          // Update the "detail" field of the document with the updated event list
          final updatedEvents = {
            DateFormat('yyyy-MM-dd').format(_selectedDate!): eventList
          };
          myEvents.reference.update({"detail": updatedEvents});
        }
      }
    }
  }

  void deleteEvent(
      QueryDocumentSnapshot<Map<String, dynamic>> myEvents, dynamic event) {
    final events = myEvents["detail"];
    if (events is Map<String, dynamic>) {
      final eventList = events[DateFormat('yyyy-MM-dd').format(_selectedDate!)];
      final getdblist =
          getEventOnDB[DateFormat('yyyy-MM-dd').format(_selectedDate!)];
      if (eventList is List<dynamic>) {
        var deleteIndex;
        eventList.asMap().forEach((index, getindex) {
          if (getindex.toString() == event.toString()) {
            deleteIndex = index;
          }
        });
        print('Before remove: $eventList');
        eventList.removeAt(deleteIndex);
        getdblist.removeAt(deleteIndex);
        print('After remove: $eventList');
        if (eventList.length == 0) {
          myEvents.reference.delete();
        } else if (eventList.length > 0) {
          myEvents.reference.update({'detail': events});
        }
      }
    }
  }

  Map<String, List<Map<String, dynamic>>> addTasks() {
    List<Map<String, dynamic>> tasks = [];
    // Chemical task
    final waterDay = waterDuration;
    final chemDay = chemiDuration;
    tasks.add({
      'eventTitle': 'ตัดแต่งกิ่ง',
      'Note': "",
      'due_date': DateFormat('yyyy-MM-dd').format(getActivityDate)
    });
    var wateringStartDate3 = getActivityDate!.add(Duration(days: 2));
    tasks.add({
      'eventTitle': 'ให้น้ำ',
      'Note':
          'ใส่ปุ๋ยเคมีสูตร 15-15-15 ผสม 46-0-0 สัดส่วน 1:1 อัตรา 1-2 กิโลกรัมต่อต้น',
      'due_date': DateFormat('yyyy-MM-dd').format(wateringStartDate3)
    });

    var wateringStartDate = getActivityDate!.add(Duration(days: 7));
    for (var i = 0; i < 120 / waterDay; i++) {
      var wateringDate = wateringStartDate.add(Duration(days: i * waterDay));
      tasks.add({
        'eventTitle': 'ให้น้ำ',
        'Note': "",
        'due_date': DateFormat('yyyy-MM-dd').format(wateringDate)
      });
    }

    var chemStartDate = getActivityDate.add(Duration(days: 30));
    for (var i = 0; i < 90 / chemDay; i++) {
      var chemDate = chemStartDate.add(Duration(days: i * chemDay));
      tasks.add({
        'eventTitle': 'พ่นสารเคมี',
        'Note': 'เน้นสารเคมีที่กระตุ้นการเจริญเติบโตของใบและดอกลำไย',
        'due_date': DateFormat('yyyy-MM-dd').format(chemDate)
      });
    }
    var fertilizeDate = getActivityDate.add(Duration(days: 120));
    tasks.add({
      'eventTitle': 'ราดสารเคมี',
      'Note': "ให้สารโพแทสเซียมคลอเรตบริสุทธิ์อัตรา 60-80 กรัม/น้ำ 40-60 ลิตร",
      'due_date': DateFormat('yyyy-MM-dd').format(fertilizeDate)
    });

    var wateringStartDate2 = getActivityDate.add(Duration(days: 125));
    for (var i = 0; i < 150 / waterDay; i++) {
      var wateringDate2 = wateringStartDate2.add(Duration(days: i * waterDay));
      tasks.add({
        'eventTitle': 'ให้น้ำ',
        'Note': "",
        'due_date': DateFormat('yyyy-MM-dd').format(wateringDate2)
      });
    }

    var chemStartDate2 = getActivityDate.add(Duration(days: 127));
    for (var i = 0; i < 150 / chemDay; i++) {
      var chemDate2 = chemStartDate2.add(Duration(days: i * chemDay));
      tasks.add({
        'eventTitle': 'พ่นสารเคมี',
        'Note': 'ใช้สารเคมีตามวัชพืชลำไย',
        'due_date': DateFormat('yyyy-MM-dd').format(chemDate2)
      });
    }

    var fertilizeDate3 = getActivityDate.add(Duration(days: 300));
    tasks.add({
      'eventTitle': 'ให้น้ำ',
      'Note': 'ใส่ปุ๋ย 15-15-15 ก่อนเก็บ',
      'due_date': DateFormat('yyyy-MM-dd').format(fertilizeDate3)
    });

    var collectDate = getActivityDate.add(Duration(days: 330));
    tasks.add({
      'eventTitle': 'เก็บเกี่ยว',
      'Note': "",
      'due_date': DateFormat('yyyy-MM-dd').format(collectDate)
    });

    // Sort tasks by due date
    tasks.sort((a, b) => a['due_date']!.compareTo(b['due_date']!));

    // Create a map mapping dates to tasks
    Map<String, List<Map<String, dynamic>>> taskMap = {};
    for (Map<String, dynamic> task in tasks) {
      String dateKey = task['due_date']!;
      if (!taskMap.containsKey(dateKey)) {
        taskMap[dateKey] = [];
      }
      taskMap[dateKey]!.add({
        'eventTitle': task['eventTitle']!,
        'Farm': selectedFarm.toString(),
        'Note': task['Note'],
        'status': 'waitting' /* ,'Note': task['Note']! */
      });
    }

    // Return the task map
    return taskMap;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

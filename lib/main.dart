import 'package:app_project/farm_page.dart';
import 'package:app_project/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(_MainPage());
  Firebase.initializeApp();
}

final GoogleSignIn? _googleSignIn = GoogleSignIn();
TextEditingController _forgotpasswordController = TextEditingController();

class _MainPage extends StatelessWidget {
  final _route = <String, WidgetBuilder>{
    '/mainPage': (BuildContext context) => mainPage(),
    '/FarmPage': (BuildContext context) => FarmPage(),
  };
  _MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale('th', 'TH'),
          supportedLocales: [
            const Locale('en', 'US'), // English
            const Locale('th', 'TH'), // Thai
          ],
          routes: _route,
          theme: ThemeData(
            colorScheme: ThemeData().colorScheme.copyWith(
                  secondary: HexColor("#067D68"),
                ),
          ),
          home: mainPage(),
        );
      },
    );
  }
}

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

bool _obscurepwd = true;
bool _obscurepwd2 = true;

class _mainPageState extends State<mainPage> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final signUp_emailController = TextEditingController();
  final signUp_pwdController = TextEditingController();
  final signUp_pwd2Controller = TextEditingController();
  void _loginDialog() {
    slideDialog.showSlideDialog(
        context: context,
        child: StatefulBuilder(builder: (context, setState) {
          return Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: 0.7.sh,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.48, 0.9, 1],
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
                      Text('เข้าสู่ระบบ',
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
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            cursorColor: HexColor("#067D68"),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'อีเมล',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.04.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.06.sh,
                          child: TextFormField(
                            obscureText: _obscurepwd,
                            controller: pwdController,
                            cursorColor: HexColor("#067D68"),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    print(_obscurepwd);
                                    _obscurepwd = !_obscurepwd;
                                  });
                                },
                                icon: Icon(_obscurepwd
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'รหัสผ่าน',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.1.sw, left: 0.1.sw),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 12.sp),
                                ),
                                onPressed: () {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Text(
                                              'รีเซ็ตรหัสผ่าน',
                                              style: GoogleFonts.notoSansThai(
                                                textStyle: TextStyle(
                                                    color: HexColor("#2F4858"),
                                                    letterSpacing: .25,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.sp),
                                              ),
                                            ),
                                            content: Container(
                                              height: 0.15.sw,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                controller:
                                                    _forgotpasswordController,
                                                cursorColor:
                                                    HexColor("#067D68"),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor:
                                                      HexColor("#D9D9D9"),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: 'กรอกอีเมลของคุณ',
                                                  hintStyle:
                                                      GoogleFonts.notoSansThai(
                                                    textStyle: TextStyle(
                                                        color: Colors.grey[700],
                                                        letterSpacing: .25,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    child: Text(
                                                      'ยกเลิก',
                                                      style: GoogleFonts
                                                          .notoSansThai(
                                                        textStyle: TextStyle(
                                                            color: Colors.red,
                                                            letterSpacing: .25,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16.sp),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _forgotpasswordController
                                                          .clear();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'ยืนยัน',
                                                      style: GoogleFonts
                                                          .notoSansThai(
                                                        textStyle: TextStyle(
                                                            color: Colors.black,
                                                            letterSpacing: .25,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16.sp),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      String email =
                                                          _forgotpasswordController
                                                              .text;
                                                      if (email != "") {
                                                        FirebaseAuth.instance
                                                            .sendPasswordResetEmail(
                                                                email: email)
                                                            .then((value) {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "ระบบได้ทำการส่งอีเมลรีเซ็ตรหัสผ่านให้คุณแล้ว",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.green,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 10.sp,
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        }).catchError((error) {
                                                          String errorMessage =
                                                              "เกิดข้อผิดพลาดขณะส่งอีเมลรีเซ็ตรหัสผ่าน";
                                                          if (error
                                                              is FirebaseAuthException) {
                                                            if (error.code ==
                                                                'user-not-found') {
                                                              errorMessage =
                                                                  "ไม่พบอีเมลนี้ในระบบ";
                                                            }
                                                          }
                                                          Fluttertoast
                                                              .showToast(
                                                            msg: errorMessage,
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 10.sp,
                                                          );
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "กรุณากรอกอีเมลของคุณ",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 10.sp);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ));
                                },
                                child: Text(
                                  'ลืมรหัสผ่าน',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#2F4858"),
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp),
                                  ),
                                )),
                            TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 12.sp),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _registerDialog();
                                },
                                child: Text(
                                  'สมัครสมาชิก',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#2F4858"),
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp),
                                  ),
                                )),
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
                            onPressed: () {
                              signIn();
                            },
                            child: Text(
                              'เข้าสู่ระบบ',
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
                      Padding(
                        padding: EdgeInsets.only(top: 0.095.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.05.sh,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#1778F2"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 5),
                            onPressed: () async {
                              await signInWithFacebook();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                      child: homepage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/images/facebook_logo.png"),
                                  width: 0.065.sw,
                                ),
                                SizedBox(width: 0.025.sw),
                                Text(
                                  'ดำเนินต่อด้วย Facebook',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#FFFFFF"),
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.035.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.05.sh,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 5),
                            onPressed: () async {
                              await signInWithGoogle();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                      child: homepage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/images/google_logo.png"),
                                  width: 0.06.sw,
                                ),
                                SizedBox(width: 0.025.sw),
                                Text(
                                  'ดำเนินต่อด้วย Google',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.grey[800],
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  void _registerDialog() {
    final GlobalKey<FormState> _form = GlobalKey<FormState>();
    slideDialog.showSlideDialog(
        context: context,
        child: StatefulBuilder(builder: (context, setState) {
          return Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: 0.7.sh,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.48, 0.9, 1],
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
                      Text('สมัครสมาชิก',
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
                            keyboardType: TextInputType.emailAddress,
                            controller: signUp_emailController,
                            cursorColor: HexColor("#067D68"),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'อีเมล',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.04.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.06.sh,
                          child: TextFormField(
                            obscureText: _obscurepwd2,
                            controller: signUp_pwdController,
                            cursorColor: HexColor("#067D68"),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    print(_obscurepwd2);
                                    _obscurepwd2 = !_obscurepwd2;
                                  });
                                },
                                icon: Icon(_obscurepwd2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'รหัสผ่าน',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.04.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.06.sh,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null) {
                                Fluttertoast.showToast(
                                    msg: "กรูณายืนยันรหัสผ่าน",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 10.sp);
                                emailController.clear();
                                pwdController.clear();
                              } else if (value.toString() !=
                                  signUp_pwdController.toString()) {
                                Fluttertoast.showToast(
                                    msg: "รหัสผ่านไม่ตรงกัน",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 10.sp);
                                emailController.clear();
                                pwdController.clear();
                              }
                              return null;
                            },
                            obscureText: _obscurepwd,
                            controller: signUp_pwd2Controller,
                            cursorColor: HexColor("#067D68"),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    print(_obscurepwd);
                                    _obscurepwd = !_obscurepwd;
                                  });
                                },
                                icon: Icon(_obscurepwd
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'ยืนยันรหัสผ่าน',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.1.sw, left: 0.1.sw),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 12.sp),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _loginDialog();
                                },
                                child: Text(
                                  'เข้าสู่ระบบ',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#2F4858"),
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp),
                                  ),
                                )),
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
                            onPressed: () {
                              if (signUp_pwdController.text.trim() ==
                                  signUp_pwd2Controller.text.trim()) {
                                singUp();
                              } else if (signUp_pwd2Controller.text
                                  .trim()
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "กรุณายืนยันรหัสผ่าน",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 10.sp);
                                emailController.clear();
                                pwdController.clear();
                              } else if (signUp_pwdController.text.trim() !=
                                  signUp_pwd2Controller.text.trim()) {
                                print(signUp_pwd2Controller.text);
                                Fluttertoast.showToast(
                                    msg: "รหัสผ่านไม่ตรงกัน",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 10.sp);
                                emailController.clear();
                                pwdController.clear();
                              }
                            },
                            child: Text(
                              'สมัครสมาชิก',
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
                      Padding(
                        padding: EdgeInsets.only(top: 0.095.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.05.sh,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#1778F2"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 5),
                            onPressed: () async {
                              await signInWithFacebook();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                      child: homepage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/images/facebook_logo.png"),
                                  width: 0.065.sw,
                                ),
                                SizedBox(width: 0.025.sw),
                                Text(
                                  'ดำเนินต่อด้วย Facebook',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: HexColor("#FFFFFF"),
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.035.sw),
                        child: SizedBox(
                          width: 0.75.sw,
                          height: 0.05.sh,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 5),
                            onPressed: () async {
                              await signInWithGoogle();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                      child: homepage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/images/google_logo.png"),
                                  width: 0.06.sw,
                                ),
                                SizedBox(width: 0.025.sw),
                                Text(
                                  'ดำเนินต่อด้วย Google',
                                  style: GoogleFonts.notoSansThai(
                                    textStyle: TextStyle(
                                        color: Colors.grey[800],
                                        letterSpacing: .25,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.4,
            0.98,
          ],
          colors: [
            HexColor("#067D68"),
            HexColor("#2F4858"),
          ],
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 0.5.sw,
                ),
                Text(
                  'WELCOME',
                  style: GoogleFonts.notoSansThai(
                    textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w800,
                        fontSize: 26.sp),
                  ),
                ),
                Text(
                  'เริ่มต้นการวางแผนสวนของคุณ',
                  style: GoogleFonts.notoSansThai(
                    textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: .25,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp),
                  ),
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Text(
                  'คุณมีบัญชีอยู่แล้วหรือไม่',
                  style: GoogleFonts.notoSansThai(
                    textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp),
                  ),
                ),
                SizedBox(
                  height: 0.02.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 0.39.sw,
                      height: 0.05.sh,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            elevation: 3),
                        onPressed: () {
                          _loginDialog();
                        },
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: GoogleFonts.notoSansThai(
                            textStyle: TextStyle(
                                color: HexColor("#2F4858"),
                                letterSpacing: .25,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 0.39.sw,
                      height: 0.05.sh,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#067D68"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            elevation: 3),
                        onPressed: () {
                          _registerDialog();
                        },
                        child: Text(
                          'สมัครสมาชิก',
                          style: GoogleFonts.notoSansThai(
                            textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .25,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future singUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    String errorMessage;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: signUp_emailController.text.trim(),
          password: signUp_pwdController.text.trim());
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: homepage()));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "อีเมลนี้ถูกใช้งานแล้ว";
          break;
        case "invalid-email":
          errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
          break;
        case "operation-not-allowed":
          errorMessage = "ฟังก์ชันนี้ยังไม่ถูกเปิดใช้งาน";
          break;
        case "weak-password":
          errorMessage = "รหัสผ่านของคุณไม่ปลอดภัย";
          break;
        default:
          errorMessage = "กรุณากรอกข้อมูลให้ครบ";
      }
      if (errorMessage != null) {
        return {
          Navigator.of(context).pop(),
          Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 10.sp),
          emailController.clear(),
          pwdController.clear()
        };
      }
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<GoogleSignInAccount> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      return googleUser!;
    } catch (error) {
      // Show a toast message with the error message
      Fluttertoast.showToast(
          msg: 'เกิดข้อผิดพลาด: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.sp);

      throw error;
    }
  }

  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    String errorMessage;

    await Firebase.initializeApp();
    try {
      print(signUp_pwd2Controller.text);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: pwdController.text.trim());
      print(emailController.toString());
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: homepage()));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
          break;
        case "user-not-found":
          errorMessage = "ไม่มีบัญชีนี้ในฐานข้อมูล";
          break;
        case "user-disabled":
          errorMessage = "บัญชีของคุณถูกระงับ";
          break;
        case "wrong-password":
          errorMessage = "รหัสผ่านไม่ถูกต้อง";
          break;
        default:
          errorMessage = "กรุณากรอกข้อมูลให้ครบ";
      }
      if (errorMessage != null) {
        return {
          Navigator.of(context).pop(),
          Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 10.sp),
          emailController.clear(),
          pwdController.clear()
        };
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/home.dart';
import 'dart:io';
import 'dart:ui';

const String appTitle = 'CryptoSafe';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(appTitle);
    // setWindowMinSize(const Size(720, 830));
    setWindowFrame(const Rect.fromLTWH(0, 0, 1200, 720));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> myColor = {
      50: Color.fromRGBO(24, 22, 61, .1),
      100: Color.fromRGBO(24, 22, 61, .2),
      200: Color.fromRGBO(24, 22, 61, .3),
      300: Color.fromRGBO(24, 22, 61, .4),
      400: Color.fromRGBO(24, 22, 61, .5),
      500: Color.fromRGBO(24, 22, 61, .6),
      600: Color.fromRGBO(24, 22, 61, .7),
      700: Color.fromRGBO(24, 22, 61, .8),
      800: Color.fromRGBO(24, 22, 61, .9),
      900: Color.fromRGBO(24, 22, 61, 1),
    };
    MaterialColor colorCustom = MaterialColor(0xFF18163d, myColor);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.grey),
        accentColor: Colors.white,
        primarySwatch: colorCustom,
        primaryColor: Colors.white,
        canvasColor: const Color(0xFFfafafa),
        // unselectedWidgetColor: const Color(0xFFfafafa),
        scaffoldBackgroundColor: Colors.white,
      ),
      // theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF13171A)),
      home: const MyHomePage(title: ''),
    );
  }
}

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
    setWindowMinSize(const Size(720, 830));
    setWindowFrame(const Rect.fromLTWH(0, 0, 720, 900));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: const Color(0xFF13171A),
        canvasColor: const Color(0xFFfafafa),
        // unselectedWidgetColor: const Color(0xFFfafafa),
        scaffoldBackgroundColor: const Color(0xFF13171A),
      ),
      // theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF13171A)),
      home: const MyHomePage(title: ''),
    );
  }
}

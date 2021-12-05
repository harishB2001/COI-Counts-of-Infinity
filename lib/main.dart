import 'package:coi/screens/apodScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light
  ));
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
     // darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
        title: "Counts Of Infinity",
      home: Material(
      
        color: Colors.black,
        child: SplashScreenView(
            backgroundColor: Colors.black,
            duration: 5000,
            imageSize: 300,
            imageSrc: 'assets/infinity.gif',
            text: "Counts Of Infinity",
            textStyle: GoogleFonts.patuaOne(
                color: Colors.white, fontSize: 40, wordSpacing: 1),
            colors: const [
              Colors.white,
              Colors.blue,
              Colors.orange,          
              Colors.red
            ],
            textType: TextType.ColorizeAnimationText,
            navigateRoute: const ApodScreen()),
      ),
    );
  }
}

//title: "Counts Of Infinity"


/*
The include file 'package:flutter_lints/flutter.yaml' in 'f:\WORKSPACE\FlutterProjects\app_store\counts_of_infinity\analysis_options.yaml' can't be found when analyzing 'f:\WORKSPACE\FlutterProjects\app_store\counts_of_infinity'.
*/
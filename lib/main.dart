import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:todo_app/layout/home_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        HomeLayout.homeScreenRoute: (context) => HomeLayout(),
      },
      home: SplashScreen(
        seconds: 3,
        loadingText: Text('loading..'),
        loaderColor: Colors.grey[800],
        backgroundColor: Colors.white,
        title: Text(
          'Todo App',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        navigateAfterSeconds: HomeLayout(),
        image: Image.asset('assets/images/splash_screen.png'),
        photoSize: 120.0,
      ),
    );
  }
}

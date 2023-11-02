import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:miata_screen/compassui.dart';
import 'package:miata_screen/speedometer.dart';
import 'package:miata_screen/squareButton.dart';
import 'package:text_scroll/text_scroll.dart';
import 'gifSpeedPlayer.dart';
import 'musicControl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  // await WindowManager.instance.setMinimumSize(const Size(1280, 428));
  // await WindowManager.instance.setMaximumSize(const Size(1280, 428));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "KarmaticArcade",
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  Widget drawerContent = Container();
  double speed = 10;
  int randomGifIndex = 1;
  bool isGoingUpDemoSpeed = true;
  Random random = Random();
  double degreeDirectionTempDemo = 0.1;
  double degreeDirection = 0;

  @override
  void initState() {
    speedSpinning();
    super.initState();
  }

  speedSpinning() async {
    setState(() {
      degreeDirectionTempDemo++;
      degreeDirection = degreeDirectionTempDemo % 360;
      isGoingUpDemoSpeed ? speed++ : speed--;
      //print(degreeDirection.toString());
    });
    await Future.delayed(Duration(milliseconds: 30));
    if (speed > 100) {
      setState(() {
        isGoingUpDemoSpeed = false;
      });
    }
    if (speed < 0) {
      setState(() {
        isGoingUpDemoSpeed = true;
      });
    }
    speedSpinning();
  }

  double randomDouble() {
    return random.nextDouble() * 120.0;
  }

  @override
  Widget build(BuildContext context) {
    // double angle = CompassCalc.calculateBearing(52.5200, 13.4050, 48.8566,
    //     2.3522); //from point first 2 inputs, to-point last 2 parameters
    // print('The angle between the coordinates is $angle degrees.');
    return Scaffold(
      key: _key,
      drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
          ),
          width: 600,
          child: Container(
            width: 600,
            height: double.infinity,
            color: Colors.white,
            child: drawerContent,
          )),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/background1.jpg'),
            // Replace with your image path
            fit: BoxFit.cover, // You can adjust the fit as needed
          )),
          height: 400,
          width: 1280,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  height: 170,
                  width: 430,
                  child: MusicControl(),
                ),
              ),
              Positioned(
                left: 10,
                top: 190,
                child: MainMenuButton("debug", () {
                  setState(() {
                    drawerContent = ListView(
                      children: [
                        ListTile(
                          title: Text(' - DEBUG MENU - '),
                        ),
                        ListTile(
                          title: Text(''),
                        ),
                        ListTile(
                          title: Text('Version: $speed'),
                        ),
                      ],
                    );
                  });
                  _key.currentState!.openDrawer();
                }, "assets/debug.jpg", 200, 200),
              ),
              Positioned(
                  left: 220,
                  top: 190,
                  child: MainMenuButton("LED\nControl", () {
                    setState(() {
                      drawerContent = Center(child: Text('led control'));
                    });
                    _key.currentState!.openDrawer();
                  }, "assets/led.jpeg", 200, 200)),
              Positioned(
                  left: 430,
                  top: 190,
                  child: MainMenuButton("garage", () {
                    setState(() {
                      drawerContent = Center(child: Text('garage'));
                    });
                    _key.currentState!.openDrawer();
                  }, "assets/garage.jpeg", 200, 200)),
              Positioned(
                  left: 850,
                  top: 190,
                  child: MainMenuButton("XXX", () {
                    setState(() {
                      drawerContent = Center(child: Text('X'));
                    });
                    _key.currentState!.openDrawer();
                  }, "assets/placeholder.jpeg", 200, 200)),
              Positioned(
                  left: 450,
                  top: 10,
                  child: CompassUi(
                    x: degreeToOffset(degreeDirection),
                    y: 0,
                    imagePath: "assets/compass.png",
                  )),
              Positioned(
                  left: 1070,
                  top: 190,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      randomGifIndex++;
                    }),
                    child: GifWidget(
                        "assets/randomgifs/${randomGifIndex % 5 + 1}.gif"),
                  )),
              Positioned(
                left: 445,
                top: 72,
                child: Container(
                  child: SpeedoMeterBars(speed),
                  height: 100,
                  width: 833,
                  // color: Colors.white.withOpacity(.2),
                ),
              ),
              Positioned(
                left: 1030,
                top: 72,
                child: Container(
                  child: SpeedoMeterNumber(speed),
                  height: 100,
                  width: 200,
                  // color: Colors.white.withOpacity(.2),
                ),
              ),
              Positioned(
                  left: 560,
                  top: 130,
                  child: IgnorePointer(
                      child: Container(
                          height: 350,
                          width: 350,
                          child: Image.asset("assets/pda.png")))),
              Positioned(
                  left: 680,
                  top: 235,
                  child: IgnorePointer(
                      child: Container(
                    child: TextScroll(
                      'This is the sample text for Flutter TextScroll widget. ',
                      style: TextStyle(color: Colors.white),
                      velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                      pauseBetween: Duration(milliseconds: 1000),
                      mode: TextScrollMode.bouncing,
                    ),
                    height: 105,
                    width: 105,
                  )))
            ],
          )),
    );
  }

  double degreeToOffset(double degree) {
    return -degree * (770 / 180) - 370;
  }
}


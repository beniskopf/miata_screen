import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:miata_screen/compassui.dart';
import 'package:miata_screen/service.dart';
import 'package:miata_screen/speedometer.dart';
import 'package:miata_screen/squareButton.dart';
import 'GpsDto.dart';
import 'bashCommands.dart';
import 'colorPickerDrawer.dart';
import 'compass.dart';
import 'debugDrawer.dart';
import 'musicControl.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
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
  double speed = 0;
  int randomGifIndex = 1;
  bool isGoingUpDemoSpeed = true;
  Random random = Random();
  double degreeDirectionTempDemo = 0.1;
  double degreeDirection = 0;
  String songTitle = "";
  String artistName = "";
  String time = "";
  String date = "";
  GpsDto? gpsTemp;

  @override
  void initState() {
    //songInfoSpinning();
    //speedSpinningDemo();
    //timeAndDateSpinning();
    gpsSpinning();
    super.initState();
  }

  timeAndDateSpinning() async {
    String timereturn = await ServiceClass.runBashCommand(BashCommands.getTime);
    String datereturn = await ServiceClass.runBashCommand(BashCommands.getDate);
    // print(time + date);
    setState(() {
      time = timereturn ?? "";
      date = datereturn ?? ""; //char check would be sweet
    });
    await Future.delayed(Duration(seconds: 59));
    timeAndDateSpinning();
  }

  songInfoSpinning() async {
    String payload =
        await ServiceClass.runBashCommand(BashCommands.getSongInfo1);
    if (payload == "error") {
      payload = await ServiceClass.runBashCommand(BashCommands.getSongInfo2);
    }
    Map<String, String> artistSongMap =
        ServiceClass.extractArtistAndTitle(payload);
    setState(() {
      songTitle = artistSongMap['Title'] ?? "x";
      artistName = artistSongMap['Artist'] ?? "x";
    });
    await Future.delayed(Duration(seconds: 5));
    songInfoSpinning();
  }

  gpsSpinning() async {
    // final httpResponse =
    //     await http.get(Uri.http('127.0.0.1', '5000/get_gps_data'));
    // GpsDto response =
    //     GpsDto.fromJson(httpResponse.body as Map<String, dynamic>);
    final rawData = await ServiceClass.runBashCommand("curl http://127.0.0.1:5000/get_gps_data");
    print(rawData);
    Map<String, dynamic> jsonMap = json.decode(rawData);
    GpsDto response =
    GpsDto.fromJson(jsonMap);
    setState(() {
      speed = response.speed ?? response.speed! * 3.6;

      if (gpsTemp != null &&
          gpsTemp?.longitude != null &&
          gpsTemp?.latitude != null &&
          response != null &&
          response.latitude != null &&
          response.longitude != null) {
        degreeDirection = CompassCalc.calculateBearing(gpsTemp!.latitude!,
            gpsTemp!.longitude!, response.latitude!, response.longitude!);
      }
      gpsTemp = response;
    });
    await Future.delayed(Duration(milliseconds: 500));
    gpsSpinning();
  }

  speedSpinningDemo() async {
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
    speedSpinningDemo();
  }

  double randomDouble() {
    return random.nextDouble() * 120.0;
  }

  @override
  Widget build(BuildContext context) {
    //TrackInfo.extractArtistAndTitle("input");
    // double angle = CompassCalc.calculateBearing(52.5200, 13.4050, 48.8566,
    //     2.3522); //from point first 2 inputs, to-point last 2 parameters
    // print('The angle between the coordinates is $angle degrees.');
    return Scaffold(
      key: _key,
      drawer: Drawer(
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
          ),
          width: 600,
          child: Container(
            width: 600,
            height: double.infinity,
            //color: Colors.white,
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
                  child: MusicControl(songTitle, artistName),
                ),
              ),
              Positioned(
                left: 10,
                top: 190,
                child: MainMenuButton("debug", () {
                  setState(() {
                    drawerContent = ListView.separated(
                      itemCount: DrawerContentClass.debugContent().length,
                      itemBuilder: (BuildContext context, int index) {
                        return DrawerContentClass.debugContent()[index];
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 5.0);
                      },
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
                      drawerContent = ColorPicker();
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
              Positioned(left: 850, top: 190, child: VolumeControl()),
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
                      child: Container()
                      // child: GifWidget(
                      //     "assets/randomgifs/resized_x${randomGifIndex % 29 + 1}.gif"),
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
                    child: Column(
                      children: [
                        Text(
                          time.replaceAll(RegExp(r'\n'), ''),
                          style: TextStyle(fontSize: 27, color: Colors.white),
                        ),
                        Text(
                          date.replaceAll(RegExp(r'\n'), ''),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
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

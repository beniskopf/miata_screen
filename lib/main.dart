import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterpi_gstreamer_video_player/flutterpi_gstreamer_video_player.dart';
import 'package:miata_screen/service.dart';
import 'package:miata_screen/speedometer.dart';
import 'package:miata_screen/squareButton.dart';
import 'package:provider/provider.dart';
import 'bashCommands.dart';
import 'brightnessAdjuster.dart';
import 'chewieDemo.dart';
import 'colorPickerDrawer.dart';
import 'debugDrawer.dart';
import 'filepicker.dart';
import 'musicControl.dart';

Future<void> main() async {
  FlutterpiVideoPlayer.registerWith();
  runApp(const MyApp());
  // runApp(const ChewieDemo(),);
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
      home: ChangeNotifierProvider(
        create: (context) => BrightnessProvider(),
        child: MyHomePage(),
      ),
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

  int randomGifIndex = 1;
  int gifDirCount = -1;

  Random random = Random();

  String time = "";
  String date = "";

  bool isLoading = false;

  late Map<String, dynamic> configData;

  @override
  void initState() {
    super.initState();
    ServiceClass.runBashCommand(BashCommands.btconnect);
    loadLedConfig();
    // loadConfig();
    //timeAndDateSpinning();
    countGifDirFiles();
  }

  // loadConfig() async {
  //   configData = await ServiceClass.readConfigFile();
  //   Provider.of<BrightnessProvider>(context, listen: false)
  //       .setBrightness(configData["defaultBrightness"]/100);
  // }

  loadLedConfig() async {
    Map<String, dynamic> configData = await ServiceClass.readConfigFile();
    if (configData["ledColor"] != null) {
      await ServiceClass.runBashCommand(
          BashCommands.changeColor + configData["ledColor"]);
    }
  }

  countGifDirFiles() async {
    String temp =
        await ServiceClass.runBashCommand(BashCommands.getGifDirFileCount);
    gifDirCount = int.parse(temp);
    setState(() {
      randomGifIndex = Random().nextInt(gifDirCount);
    });
  }

  double randomDouble() {
    return random.nextDouble() * 120.0;
  }

  @override
  Widget build(BuildContext context) {
    double brightness = Provider.of<BrightnessProvider>(context).brightness;
    //TrackInfo.extractArtistAndTitle("input");
    // double angle = CompassCalc.calculateBearing(52.5200, 13.4050, 48.8566,
    //     2.3522); //from point first 2 inputs, to-point last 2 parameters
    // print('The angle between the coordinates is $angle degrees.');
    return BrightnessAdjuster(
      child: Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
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
                    child: MusicControl(),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 190,
                  child: MainMenuButton("settings", () {
                    setState(() {
                      drawerContent = ListView.separated(
                        itemCount:
                            DrawerContentClass.debugContent(context).length,
                        itemBuilder: (BuildContext context, int index) {
                          return DrawerContentClass.debugContent(
                              context)[index];
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 5.0);
                        },
                      );
                    });
                    _key.currentState!.openDrawer();
                  }, "assets/settings.jpg", 200, 200),
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
                    child: MainMenuButton("garage", () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyFileListWidget(directoryPath: '/home/rp/media', context: context,)),
                      );
                      // setState(() {
                      //   isLoading = true;
                      // });
                      // await Future.delayed(Duration(seconds: 5));
                      // String temp = await ServiceClass.runBashCommand(
                      //     BashCommands.toggleGarage);
                      // setState(() {
                      //   isLoading = false;
                      // });
                      // if (temp.contains("relay active")) {
                      //   ServiceClass.showDialogBox(context, "action ok");
                      // } else {
                      //   ServiceClass.showDialogBox(
                      //       context, "action failed, back to the lobby");
                      // }
                    }, "assets/garage.jpeg", 200, 200)),
                Positioned(left: 850, top: 190, child: VolumeControl()),
                Positioned(
                    left: 950,
                    top: 190,
                    child: BrightnessControl(() {
                      Provider.of<BrightnessProvider>(context, listen: false)
                          .setBrightness(brightness - 0.1);
                    }, () {
                      Provider.of<BrightnessProvider>(context, listen: false)
                          .setBrightness(brightness + 0.1);
                    })),
                if (gifDirCount > 0)
                  Positioned(
                      left: 1070,
                      top: 190,
                      child: GestureDetector(
                          onTap: () => setState(() {
                                randomGifIndex = Random().nextInt(gifDirCount);
                              }),
                          child: Container(
                              width: 200,
                              height: 200,
                              child: Image.file(
                                File(
                                    "/home/rp/randomgifs/output/resized_x${randomGifIndex % gifDirCount + 1}.gif"),
                                fit: BoxFit.cover, // Adjust the fit as needed
                              )))),
                Positioned(
                  left: 445,
                  top: 10,
                  child: Container(
                    child: SpeedoMeterBars(),
                    height: 170,
                    width: 833,
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
                    ))),
                isLoading
                    ? Container(
                        color: Colors.black.withOpacity(.8),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container()
              ],
            )),
      ),
    );
  }
}

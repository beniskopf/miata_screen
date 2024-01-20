import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miata_screen/service.dart';
import 'package:miata_screen/main.dart';
import 'bashCommands.dart';
import 'changeMac.dart';

class DrawerContentClass {
  static Widget getListTileButton(String title, Function onPress) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                0.0), // Set the radius to 0 for square corners
          ),
        ),
        onPressed: () => onPress(),
        child: Text(
          title,
          style: TextStyle(fontSize: 30),
        ));
  }

  static List<Widget> debugContent(BuildContext context) {
    return [
      getListTileButton("restart raspberry", () {
        ServiceClass.runBashCommand(BashCommands.restartSystem);
      }),
      getListTileButton("shutdown raspberry", () {
        ServiceClass.runBashCommand(BashCommands.shutdownSystem);
      }),
      getListTileButton("rfkill", () async {
        String temp = await ServiceClass.runBashCommand(BashCommands.rfkill);
        ServiceClass.showDialogBox(context, temp);
      }),
      getListTileButton(BashCommands.ifconfig, () async {
        String temp = await ServiceClass.runBashCommand(BashCommands.ifconfig);
        ServiceClass.showDialogBox(context, temp);
      }),
      getListTileButton("pgrep -f flutter-pi", () async {
        String temp = await ServiceClass.runBashCommand(BashCommands.rfkill);
        ServiceClass.showDialogBox(context, temp);
      }),
      Divider(),
      getListTileButton("soft block bt", () {
        ServiceClass.runBashCommand(BashCommands.blockBt);
      }),
      getListTileButton("soft unblock bt", () {
        ServiceClass.runBashCommand(BashCommands.unblockBt);
      }),
      getListTileButton("connect bt", () {
        ServiceClass.runBashCommand(BashCommands.btconnect);
      }),
      getListTileButton("disconnect bt", () {
        ServiceClass.runBashCommand(BashCommands.btdisconnect);
      }),
      getListTileButton("pair bt", () {
        ServiceClass.runBashCommand(BashCommands.btpair);
      }),
      // getListTileButton("change bt mac address", () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ChangeMacPage()),
      //   );
      //   //_showDialog(context);
      // }),
      Divider(),
      getListTileButton("fritzbox connect", () async {
        await ServiceClass.runBashCommand(BashCommands.unblockWifi);
        String temp = await ServiceClass.runBashCommand(BashCommands.connectFritzbox);
        ServiceClass.showDialogBox(context, temp);
      }),
      getListTileButton("multimetro connect", () async {
        await ServiceClass.runBashCommand(BashCommands.unblockWifi);
        String temp = await ServiceClass.runBashCommand(BashCommands.connectMultimetro);
        ServiceClass.showDialogBox(context, temp);
      }),
      getListTileButton("soft block wifi", () async {
        ServiceClass.runBashCommand(BashCommands.blockWifi);
      }),
      getListTileButton("unblock wifi", () {
        ServiceClass.runBashCommand(BashCommands.unblockWifi);
      }),
      Divider(),
      // getListTileButton("default brightness", () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             ChangeNumberPage("defaultBrightness", "min 0 and max 100")),
      //   );
      // }),
      Divider(),
      getListTileButton("set hours", () {}),
      getListTileButton("set minutes", () {}),
      getListTileButton("set month", () {}),
      getListTileButton("set year", () {}),
    ];
  }
}

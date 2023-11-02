import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  String? text;
  Function? onPressed;
  String? assetPathToIcon;
  double? height;
  double? width;

  MainMenuButton(
      this.text, this.onPressed, this.assetPathToIcon, this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        height: width,
        width: height,
        child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            ),
            onPressed: () => onPressed!(),
            child: Stack(
              children: [
                Image.asset(assetPathToIcon!),
                Container(color: Colors.black.withOpacity(.2)),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    stops: const [0, .8],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(.2),
                    ],
                  )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          text!,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final String? assetPathToIcon;
  final double? height;
  final double? width;
  final bool showShadow;

  MainMenuButton(
      this.text, this.onPressed, this.assetPathToIcon, this.height, this.width,
      {this.showShadow = true});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          boxShadow: showShadow
              ? [
            BoxShadow(
              color: Colors.white.withOpacity(.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ]
              : [],
          image: DecorationImage(
            image: AssetImage(assetPathToIcon!),
            fit: BoxFit.cover,
          ),
          color: Colors.black.withOpacity(.2),
          gradient: LinearGradient(
            stops: const [0, .8],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(.2),
            ],
          ),
        ),
        child: InkWell(
          onTap: () => onPressed!(),
          child: SizedBox(
            height: width,
            width: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          ),
        ),
      ),
    );
  }
}

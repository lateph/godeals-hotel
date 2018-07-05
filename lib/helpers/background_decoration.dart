import 'package:flutter/material.dart';

BoxDecoration backgroundDecoration(BuildContext context) {
  AssetImage background = AssetImage('assets/images/login-bg.png');

  return new BoxDecoration(
    image: new DecorationImage(
      image: background,
      fit: BoxFit.cover,
//      colorFilter: new ColorFilter.mode(
//        const Color.fromRGBO(255, 255, 255, 0.7),
//        BlendMode.luminosity,
//      ),
    ),
  );
}

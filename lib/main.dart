import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/routes.config.dart';
import 'package:inka_msa/config/style.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Null> main() async {
  // set device orientation to only portrait up
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  AppBloc appBloc = await AppBloc.initial();

  runApp(AksaraPayApp(appBloc));
}

class AksaraPayApp extends StatefulWidget {
  final AppBloc appBloc;

  AksaraPayApp(this.appBloc, {Key key}) : super(key: key);

  @override
  _AksaraPayAppState createState() => _AksaraPayAppState();
}

class _AksaraPayAppState extends State<AksaraPayApp> {


  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      widget.appBloc,
      child: MaterialApp(
        title: 'AksaraPay',
        theme: aksaraPayDefaultTheme,
        routes: routes,
      ),
    );
  }

  @override
  void dispose() {
    widget.appBloc.dispose();
    super.dispose();
  }
}

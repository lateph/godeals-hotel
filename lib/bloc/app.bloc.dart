import 'dart:async';

import 'package:inka_msa/app.local.dart';
import 'package:inka_msa/bloc/auth.bloc.dart';
import 'package:inka_msa/states/device.state.dart';
import 'package:inka_msa/states/member.state.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBlocProvider extends InheritedWidget {
  final AppBloc appBloc;

  AppBlocProvider(this.appBloc, {@required Widget child, Key key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(AppBlocProvider oldWidget) => true;

  static AppBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AppBlocProvider)
            as AppBlocProvider)
        .appBloc;
  }
}

class AppBloc {
  final App app;

  /// common SharedPreferences for ease of use
  final SharedPreferences sharedPreferences;

  final AuthBloc auth;

  bool isLoadedLaunch = false;

  AppBloc({
    @required this.app,
    @required this.sharedPreferences,
    @required this.auth,
  });

  static Future<AppBloc> initial() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    /// Prepare AuthBloc
    AuthBloc authBloc = AuthBloc(
      memberState: MemberState(sharedPreferences),
      deviceState: DeviceState(sharedPreferences),
    );

    return AppBloc(
      app: App(),
      sharedPreferences: sharedPreferences,
      auth: authBloc,
    );
  }

  void dispose() {
    auth.dispose(); // dispose authBloc streams
  }
}

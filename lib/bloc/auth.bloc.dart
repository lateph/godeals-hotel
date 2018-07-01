import 'dart:async';
import 'dart:io';

import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:inka_msa/states/device.state.dart';
import 'package:inka_msa/states/member.state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final MemberState memberState;
  final DeviceState deviceState;

  AuthBloc({
    @required this.memberState,
    @required this.deviceState,
  }) {
    init();
  }

  final BehaviorSubject<AuthStatus> status = BehaviorSubject<AuthStatus>();

  void init() {
    // load from shared preferences
    memberState.load();
    deviceState.load();
    updateAuthStatus();
  }

  void dispose() {
    status.close();
  }

  /// define init auth status
  void updateAuthStatus() {
    final AuthStatus authStatus = AuthStatus();

    if (memberState.isLoaded && deviceState.isLoaded) {
      authStatus.isLoggedIn = true;

//      if (memberState.isVerified == 'yes') {
      authStatus.isMemberVerified = true;
//      }

//      if (deviceState.isVerified == 'yes') {
      authStatus.isDeviceVerified = true;
//      }
    }

    status.add(authStatus);
  }

  Future<Null> logout(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.authLogout],
        data: {},
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      print(response.data);
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print(e.response.data.toString());
      } else {
        print(e.message);
        print("Please check your internet connection");
      }
    }

    // remov access token
    appBloc.auth.memberState.delete();
    appBloc.auth.deviceState.delete();
    appBloc.auth.updateAuthStatus();

    // push member verification, and dispose all route before
    Navigator
        .of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}

class AuthStatus {
  bool isLoggedIn = false;
  bool isMemberVerified = false;
  bool isDeviceVerified = false;
}

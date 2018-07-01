import 'dart:async';
import 'dart:io';

import 'package:inka_msa/base/form.base.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/config/routes.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LoginForm extends BaseForm {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  LoginForm() {
    fields.addAll(<String, String>{
      'username': '',
      'password': '',
      'firebaseToken': '123476',
      'deviceIdentifier': '12345678',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      String token = await _firebaseMessaging.getToken();

      DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      fields['deviceIdentifier'] = androidInfo.id;
      fields['firebaseToken'] = token;
      print(token);
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.authLogin],
        data: {
          'username': fields['username'],
          'password': fields['password'],
          'deviceIdentifier':  androidInfo.id.toString(),
          'firebaseToken': token.toString(),
        },
        options: Options(
          contentType: ContentType.JSON,
          headers: {'X-Device-identifier': 'random'},
        ),
      );
      print(response.data);

      // save accessToken
      var member = response.data['data'];
      appBloc.auth.memberState.loadJson(member);
      appBloc.auth.deviceState.loadJson(member);
      appBloc.auth.deviceState.loadJson(member);

      appBloc.auth.memberState.save();
      appBloc.auth.deviceState.save();
      appBloc.auth.updateAuthStatus();

      // push member verification, and dispose all route before
      Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (Route<dynamic> route) => false,
          );
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print(e.response.data.toString());
        errorMessages = e.response.data['data'];
      } else {
        print(e.message);
        print("Please check your internet connection");
      }

      // pop the loader
      Navigator.of(context).pop();
    }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:inka_msa/base/form.base.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:inka_msa/pages/auth/verify_member.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class RegisterForm extends BaseForm {
  RegisterForm() {
    fields.addAll(<String, String>{
      'name': '',
      'phoneNumber': '',
      'email': '',
      'password': '',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.authRegister],
        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {'X-Device-identifier': 'random'},
        ),
      );
      print(response.data);

      // save accessToken
      var member = response.data['data'];
      appBloc.auth.memberState.loadJson(member);
      appBloc.auth.deviceState.loadJson(member['device']);

      appBloc.auth.memberState.save();
      appBloc.auth.deviceState.save();
      appBloc.auth.updateAuthStatus();

      // push member verification, and dispose all route before
      Navigator.of(context).pushNamedAndRemoveUntil(
          VerifyMemberPage.routeName, (Route<dynamic> route) => false);
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

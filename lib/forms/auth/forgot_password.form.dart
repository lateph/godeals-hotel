import 'dart:async';
import 'dart:io';

import 'package:inka_msa/base/form.base.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:inka_msa/pages/auth/forgot_password.page.dart';
import 'package:inka_msa/pages/auth/reset_password.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends BaseForm {
  ForgotPasswordForm() {
    fields.addAll(<String, String>{
      'phoneNumber': '',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.authForgotPassword],
        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {'X-Device-identifier': 'random'},
        ),
      );
      print(response.data);

      // push member verification, and dispose all route before
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return ResetPasswordPage(fields['phoneNumber']);
        },
      ), ModalRoute.withName(ForgotPasswordPage.routeName));
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

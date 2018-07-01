import 'dart:async';
import 'dart:io';

import 'package:inka_msa/base/form.base.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:inka_msa/pages/auth/verify_member.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends BaseForm {
  ChangePasswordForm() {
    fields.addAll(<String, String>{
      'oldPassword': '',
      'newPassword': '',
      'confirmNewPassword': '',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    dynamic data = {
      'oldPassword': fields['oldPassword'].toString(),
      'newPassword': fields['newPassword'].toString(),
      'confirmNewPassword': fields['confirmNewPassword'].toString(),
    };
    print(fields['email'].toString());
    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.editPassword],
        data: data,
        options: Options(
            contentType: ContentType.JSON,
            headers: {
              'Authorization': appBloc.auth.deviceState.bearer,
            }
        ),
      );
      print(response.data);

      Navigator.of(context).pop();
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print(e.response.data.toString());
        errorMessages = e.response.data['data'];
      } else {
        print(e.message);
        print("Please check your internet connection");
      }
      Navigator.of(context).pop();
      throw(e);
      // pop the loader
    }
  }
}

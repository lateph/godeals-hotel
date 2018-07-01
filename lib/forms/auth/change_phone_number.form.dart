import 'dart:async';
import 'dart:io';

import 'package:inka_msa/base/form.base.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:inka_msa/pages/auth/verify_member.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChangePhoneNumberForm extends BaseForm {
  ChangePhoneNumberForm() {
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
        Api.routes[ApiRoute.authChangePhoneNumber],
        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          }
        ),
      );
      print(response.data);

      appBloc.auth.memberState.attributes['phoneNumber'] = fields['phoneNumber'];
      appBloc.auth.memberState.save();

      Navigator
          .of(context)
          .popUntil(ModalRoute.withName('/'));
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

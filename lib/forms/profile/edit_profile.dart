import 'dart:async';
import 'dart:io';

import 'package:inka_msa/base/form.base.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:inka_msa/pages/auth/verify_member.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends BaseForm {
  EditProfileForm() {
    fields.addAll(<String, String>{
      'name': '',
      'email': '',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    dynamic data = {
      'name': fields['name'].toString(),
      'email': fields['email'].toString(),
    };
    print(fields['email'].toString());
    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.editProfile],
        data: data,
        options: Options(
            contentType: ContentType.JSON,
            headers: {
              'Authorization': appBloc.auth.deviceState.bearer,
            }
        ),
      );
      print(response.data);

      appBloc.auth.memberState.attributes['name'] = data['name'].toString();
      appBloc.auth.memberState.attributes['email'] = data['email'].toString();


      print(appBloc.auth.memberState.attributes['name']);
      print(appBloc.auth.memberState.attributes['email']);
      appBloc.auth.memberState.save();
      appBloc.auth.updateAuthStatus();

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

      // pop the loader
      Navigator.of(context).pop();
      throw(e);
    }
  }
}

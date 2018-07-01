import 'dart:async';
import 'dart:io';

import 'package:inka_msa/base/form.base.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class VerifyMemberForm extends BaseForm {
  VerifyMemberForm() {
    fields.addAll(<String, String>{
      'code': '',
    });
  }

  @override
  Future<Null> submit(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.authVerifyUser],
        data: fields,
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      print(response.data);

      appBloc.auth.memberState.attributes['isVerified'] = 'yes';
      appBloc.auth.deviceState.attributes['isVerified'] = 'yes';

      appBloc.auth.memberState.save();
      appBloc.auth.deviceState.save();
      appBloc.auth.updateAuthStatus();

      // push member verification, and dispose all route before
      Navigator
          .of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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

  Future<Null> resend(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);

    try {
      Response response = await appBloc.app.api.get(
        Api.routes[ApiRoute.authVerifyUser],
        options: Options(
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      print(response.data);
      errorMessages = Map<String, dynamic>();
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print(e.response.data.toString());
        errorMessages = e.response.data['data'];
      } else {
        print(e.message);
        print("Please check your internet connection");
      }
    }

    // pop the loader
    Navigator.of(context).pop();
  }
}

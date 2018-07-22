import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/bloc/auth.bloc.dart';
import 'package:inka_msa/pages/auth/forgot_password.page.dart';
import 'package:inka_msa/pages/auth/login.page.dart';
import 'package:inka_msa/pages/auth/register.page.dart';
import 'package:inka_msa/pages/auth/verify_device.page.dart';
import 'package:inka_msa/pages/auth/verify_member.page.dart';
import 'package:inka_msa/pages/home.page.dart';
import 'package:inka_msa/pages/main.page.dart';
import 'package:inka_msa/pages/notif.page.dart';
import 'package:inka_msa/pages/profile.edit.page.dart';
import 'package:inka_msa/pages/profile.page.dart';
import 'package:inka_msa/pages/profile.password.page.dart';
import 'package:inka_msa/pages/report/schedule.first.page.dart';
import 'package:inka_msa/pages/report/schedule.page.dart';
import 'package:inka_msa/pages/report/stock/stock.page.dart';
import 'package:inka_msa/pages/report/stock/stock2.page.dart';
import 'package:inka_msa/pages/report/train.availability.page.dart';
import 'package:inka_msa/pages/report/train.reliability.page.dart';
import 'package:inka_msa/pages/static/terms_condition.page.dart';
import 'package:flutter/widgets.dart';

import 'package:inka_msa/pages/auth/change_phone_number.page.dart';

final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);

    return firstScreen(appBloc.auth.status.value);
  },

  // auth module
  RegisterPage.routeName: (BuildContext context) => RegisterPage(),
  LoginPage.routeName: (BuildContext context) => LoginPage(),
  VerifyMemberPage.routeName: (BuildContext context) => VerifyMemberPage(),
  ChangePhoneNumberPage.routeName: (BuildContext context) =>
      ChangePhoneNumberPage(),
  VerifyDevicePage.routeName: (BuildContext context) => VerifyDevicePage(),
  ForgotPasswordPage.routeName: (BuildContext context) => ForgotPasswordPage(),
  TrainAvailabilityPage.routeName: (BuildContext context) => TrainAvailabilityPage(),
  TrainReliabilityPage.routeName: (BuildContext context) => TrainReliabilityPage(),
//  SchedulePage.routeName: (BuildContext context) => SchedulePage(),
  ScheduleFirstPage.routeName: (BuildContext context) => ScheduleFirstPage(),
  ProfilePage.routeName: (BuildContext context) => ProfilePage(),
  EditProfilePage.routeName: (BuildContext context) => EditProfilePage(),
  EditPasswordPage.routeName: (BuildContext context) => EditPasswordPage(),
  StockComponentPage.routeName: (BuildContext context) => StockComponentPage(),

  // static page
  TermsAndConditionPage.routeName: (BuildContext context) =>
      TermsAndConditionPage(),
};

Widget firstScreen(AuthStatus authStatus) {
  if (!authStatus.isLoggedIn) {
    return LoginPage();
  }

  if (!authStatus.isMemberVerified) {
    return VerifyMemberPage();
  }
  if (!authStatus.isDeviceVerified) {
    return VerifyDevicePage();
  }

  return HomePage();
}

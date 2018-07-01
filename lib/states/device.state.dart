import 'package:inka_msa/base/state.base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceState extends BaseState {
  @override
  List<String> stateAttributes() {
    return [
      'accessToken',
      'notif'
//      'isVerified',
    ];
  }

  DeviceState(SharedPreferences sharedPreferences)
      : super(
          sharedPreferencesKey: 'deviceState',
          sharedPreferences: sharedPreferences,
        );

  String get accessToken => attributes['accessToken'];

  get notif => attributes['notif'];

  String get bearer => 'Bearer ' + accessToken;
}

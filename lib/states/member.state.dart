import 'package:inka_msa/base/state.base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberState extends BaseState {
  @override
  List<String> stateAttributes() {
    return [
//      'id',
      'name',
//      'phoneNumber',
      'email',
//      'isVerified',
    ];
  }

  MemberState(SharedPreferences sharedPreferences)
      : super(
          sharedPreferencesKey: 'memberState',
          sharedPreferences: sharedPreferences,
        );

//  String get id => attributes['id'];

  String get name => attributes['name'];

//  String get phoneNumber => attributes['phoneNumber'];

  String get email => attributes['email'];

//  String get isVerified => attributes['isVerified'];
}

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class BaseState {
  final Map<String, dynamic> attributes = Map<String, dynamic>();

  final SharedPreferences sharedPreferences;

  final sharedPreferencesKey;

  bool isLoaded = false;

  BaseState({
    @required this.sharedPreferences,
    @required this.sharedPreferencesKey,
  });

  List<String> stateAttributes();

  ///
  /// Load initial data from shared preferences.
  void load() {
    String data = sharedPreferences.getString(sharedPreferencesKey);

    if (data != null) {
      loadJson(json.decode(data));
    }
  }

  void loadJson(Map<String, dynamic> json) {
    Map<String, dynamic> stateJson = json;
    stateAttributes().forEach((String attr) {
      attributes[attr] = stateJson[attr];
    });
    isLoaded = true;
  }

  void save() {
    Map<String, dynamic> stateJson = Map<String, dynamic>();

    stateAttributes().forEach((String attr) {
      stateJson[attr] = attributes[attr];
    });
    print('save data');
    print(attributes);
    sharedPreferences.setString(sharedPreferencesKey, json.encode(stateJson));
  }

  void delete() {
    sharedPreferences.remove(sharedPreferencesKey);
    isLoaded = false;
  }
}

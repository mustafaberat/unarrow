import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../game/levels.dart';

class ProgressStore extends ChangeNotifier {
  ProgressStore(this._prefs) {
    nextIndex = _prefs.getInt(PrefsKeys.progressNext) ?? 0;
    finishedAll = _prefs.getBool(PrefsKeys.progressDone) ?? false;
    if (nextIndex < 0 || nextIndex >= Levels.all.length) nextIndex = 0;
  }

  final SharedPreferences _prefs;

  late int nextIndex;
  late bool finishedAll;

  int get levelNumber => finishedAll ? Levels.all.length : nextIndex + 1;

  Future<void> onCleared(int index) async {
    if (index + 1 >= Levels.all.length) {
      finishedAll = true;
      nextIndex = Levels.all.length - 1;
    } else if (index >= nextIndex) {
      nextIndex = index + 1;
      finishedAll = false;
    }
    notifyListeners();
    await _save();
  }

  Future<void> reset() async {
    nextIndex = 0;
    finishedAll = false;
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    await _prefs.setInt(PrefsKeys.progressNext, nextIndex);
    await _prefs.setBool(PrefsKeys.progressDone, finishedAll);
  }
}

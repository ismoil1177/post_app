import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:post_app/models/language_model.dart';

sealed class RCService {
  static final rc = FirebaseRemoteConfig.instance;
  static final json = {"language": "Russia", "text": "шышлык"};

  static Future<void> init() async {
    await rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));

    await rc.setDefaults(json);
    await rc.fetchAndActivate();
    await rc.setDefaults(const {
      "isDark": true,
    });
  }

  static Language changeLanguage(String data) {
    final json = jsonDecode(data);
    final data2 = Language.fromJson(json);
    return data2;
  }

  static String get mode {
    return rc.getString("language");
  }

  static Future<void> activate() async {
    await rc.fetchAndActivate();
  }
}

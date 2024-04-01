import 'dart:io';

import 'package:adi_soft/app/types/language_type.dart';
import 'package:adi_soft/domain/entities/preference/setting_preference.dart';
import 'package:flutter/material.dart';

class PreferenceHelper {
  static Locale? language({
    String? languageKey,
  }) {
    String? currentLanguage = Platform.localeName;

    SettingPreference selectedLocale = selectLanguage(currentLanguage);
    LanguageType type = selectedLocale.dynamicValue;

    return Locale(
      type.language,
      type.country,
    );
  }
}

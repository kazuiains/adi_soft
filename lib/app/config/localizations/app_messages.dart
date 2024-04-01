import 'package:get/get.dart';
import 'package:adi_soft/app/config/localizations/languages/en_us.dart';
import 'package:adi_soft/app/config/localizations/languages/id_id.dart';
import 'package:adi_soft/app/types/language_type.dart';

class AppMessages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        LanguageType.english.id: EnUS.messages,
        LanguageType.indonesia.id: IdID.messages,
      };
}

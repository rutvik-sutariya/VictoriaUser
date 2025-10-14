import 'package:get/get.dart';
import 'lng/english.dart';
import 'lng/gujarati.dart';

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'gu_IN': guIN,
  };
}
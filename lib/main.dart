import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:victoria_user/services/constants.dart';
import 'package:victoria_user/services/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:victoria_user/view/setting_page/setting_screen.dart';
import 'services/language/local_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/get_di.dart' as di;
import 'helper/routes_helper.dart';
import 'package:permission_handler/permission_handler.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  prefs = await SharedPreferences.getInstance();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos, // iOS photo library
      Permission.storage, // Android storage
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: const Size(360, 690),

      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: LocalString(),
          locale: prefs.getString(LocalStorage.language.value) == "english"
              ? Locale('en', 'US')
              : Locale('gu', 'IN'),
          fallbackLocale: Locale('gu', 'IN'),
          // Fallback to Gujarati
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,

              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          initialRoute: prefs.getString(LocalStorage.userId.value) != null
              ? Routes.dashboardPage
              : Routes.welcomePage,
          getPages: getPages,
        );
      },
    );
  }
}

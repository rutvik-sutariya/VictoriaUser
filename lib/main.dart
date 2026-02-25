import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

// Local imports
import 'services/constants.dart';
import 'services/local_storage/local_storage.dart';
import 'services/language/local_string.dart';
import '../helper/get_di.dart' as di;
import 'helper/routes_helper.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  prefs = await SharedPreferences.getInstance();
  await di.init();

  runApp(const MyApp());
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
    FlutterNativeSplash.remove(); // removes splash safely
    _requestPermissions();
  }

  // Request app permissions
  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,     // iOS
      Permission.storage,    // Android
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    // Lock orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          // 🌍 Localization
          translations: LocalString(),
          locale: _getLocale(),
          fallbackLocale: const Locale('gu', 'IN'),

          // Prevent system font scaling issues
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },

          // 🚀 Initial Route
          initialRoute: _getInitialRoute(),
          getPages: getPages,
        );
      },
    );
  }

  // Decide initial screen
  String _getInitialRoute() {
    return prefs.getString(LocalStorage.userId.value) != null
        ? Routes.dashboardPage
        : Routes.welcomePage;
  }

  // Set locale based on saved language
  Locale _getLocale() {
    final lang = prefs.getString(LocalStorage.language.value);

    if (lang == "english") return const Locale('en', 'US');
    return const Locale('gu', 'IN');
  }
}




/// key.properties
// storePassword=123456
// keyPassword=123456
// keyAlias=key0
// storeFile=victoria-keystore.jks

/// jks generate type
// keytool -genkey -v -keystore ~/victoria_milk_release.keystore \
// -keyalg RSA -keysize 2048 -validity 10000 \
// -alias victoria_milk

/// .aab generate
// flutter clean
// flutter pub get
// flutter build appbundle --release
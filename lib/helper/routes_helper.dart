import 'package:get/get.dart';
import 'package:victoria_user/view/auth_page/login_screen.dart';
import 'package:victoria_user/view/dashboard_page/dashboard_screen.dart';
import 'package:victoria_user/view/home_page/components/notification_screen.dart';
import 'package:victoria_user/view/home_page/order_page/milk_order_screen.dart';
import 'package:victoria_user/view/language_page/language_screen.dart';
import 'package:victoria_user/view/setting_page/legal_terms_screen.dart';
import 'package:victoria_user/view/setting_page/notification_screen.dart';
import 'package:victoria_user/view/setting_page/support_screen.dart';
import 'package:victoria_user/widget/welcome_screen.dart';

class Routes {
  static String welcomePage = "/welcomePage";
  static String loginPage = "/loginPage";
  static String dashboardPage = "/dashboardPage";
  static String languagePage = "/languagePage";
  static String notificationPage = "/notificationPage";
  static String supportPage = "/supportPage";
  // static String milkOrderPage = "/milkOrderPage";
  static String notificationsPage = "/notificationsPage";
}

final getPages = [
  GetPage(
    name: Routes.welcomePage,
    page: () => WelcomeScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: Routes.loginPage,
    page: () => LoginScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: Routes.dashboardPage,
    page: () => DashboardScreen(currentIndex: 0.obs),
    transition: Transition.rightToLeft,
  ),

  GetPage(
    name: Routes.languagePage,
    page: () => LanguageScreen(),
    transition: Transition.rightToLeft,
  ),

  GetPage(
    name: Routes.notificationPage,
    page: () => NotificationScreen(),
    transition: Transition.rightToLeft,
  ),

  GetPage(
    name: Routes.supportPage,
    page: () => SupportScreen(),
    transition: Transition.rightToLeft,
  ),

  GetPage(
    name: Routes.notificationsPage,
    page: () => NotificationsScreen(),
    transition: Transition.rightToLeft,
  ),

 /* GetPage(
    name: Routes.milkOrderPage,
    page: () => MilkOrderScreen(),
    transition: Transition.rightToLeft,
  ),*/
];

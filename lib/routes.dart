import 'package:chatty/features/select_contact/screens/select_contacts_screen.dart';
import 'package:chatty/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatty/common/widgets/error_page.dart';
import 'package:chatty/features/auth/screens/login_screen.dart';
import 'package:chatty/features/auth/screens/otp_screen.dart';
import 'package:chatty/features/auth/screens/user_information.dart';
import 'package:chatty/screens/mobile_layout_screen.dart';

class AppRoutes {
  static const String loginRouteName = "login-screen";
  static const String otpRouteName = "otp-screen";
  static const String userInformationRouteName = "user-information-screen";
  static const String mobileLayoutRouteName = "mobile-layout-screen";
  static const String selectContactRouteName = "select-contact-screen";
  static const String mobileChatScreenRouteName = "mobile-chat-screen";
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.loginRouteName:
      return MaterialPageRoute(builder: ((context) => const LoginScreen()));
    case AppRoutes.otpRouteName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: ((context) => OTPScreen(verificationId: verificationId)));
    case AppRoutes.userInformationRouteName:
      return MaterialPageRoute(
          builder: ((context) => const UserInformationScreen()));
    case AppRoutes.mobileLayoutRouteName:
      return MaterialPageRoute(
          builder: ((context) => const MobileLayoutScreen()));
    case AppRoutes.selectContactRouteName:
      return MaterialPageRoute(
          builder: ((context) => const SelectContactsScreen()));
    case AppRoutes.mobileChatScreenRouteName:
      final userData = settings.arguments as Map<String, dynamic>;
      final name = userData['name'];
      final uid = userData['uid'];
      return MaterialPageRoute(
        builder: ((context) => MobileChatScreen(
              name: name,
              uid: uid,
            )),
      );
    default:
      return MaterialPageRoute(
        builder: ((context) => const Scaffold(
              body: ErrorScreen(title: "Page doesn't exist."),
            )),
      );
  }
}

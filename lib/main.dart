import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatty/colors.dart';
import 'package:chatty/common/widgets/error_page.dart';
import 'package:chatty/common/widgets/loader.dart';
import 'package:chatty/features/auth/controllers/auth_controller.dart';
import 'package:chatty/features/landing/screens/landing_screen.dart';
import 'package:chatty/firebase_options.dart';
import 'package:chatty/routes.dart';
import 'package:chatty/screens/mobile_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 15 pro size
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chatty',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: const AppBarTheme(
              color: appBarColor,
            ),
          ),
          onGenerateRoute: (settings) => generateRoute(settings),
          home: ref.watch(userDataProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (error, trace) {
              return ErrorScreen(title: error.toString());
            },
            loading: () {
              return const Loader();
            },
          ),
        );
      },
    );
  }
}

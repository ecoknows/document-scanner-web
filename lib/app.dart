import 'package:document_scanner_web/base/themes/base_theme_data.dart';
import 'package:document_scanner_web/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner_web/features/home/presentation/screens/home_screen.dart';
import 'package:document_scanner_web/features/home/presentation/widgets/user_images_dialog_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Document Scanner',
      builder: EasyLoading.init(),
      theme: BaseThemeData.primaryLightTheme,
      darkTheme: BaseThemeData.primaryDarkTheme,
      themeMode: ThemeMode.light,
      routerConfig: GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            name: HomeScreen.name,
            redirect: (context, state) {
              User? currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser == null) {
                return '/sign-in';
              }

              return null;
            },
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: HomeScreen());
            },
          ),
          GoRoute(
            path: '/sign-in',
            name: SignInScreen.name,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: SignInScreen());
            },
          ),
        ],
      ),
    );
  }
}

import 'package:document_scanner_web/base/widgets/base_scaffold.dart';
import 'package:document_scanner_web/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner_web/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner_web/features/home/presentation/widgets/create_user_tab.dart';
import 'package:document_scanner_web/features/home/presentation/widgets/storage_tab.dart';
import 'package:document_scanner_web/features/home/presentation/widgets/users_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends StatefulWidget {
  static String name = "Home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = SidebarXController(selectedIndex: 0, extended: true);

    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return BaseScaffold(
      body: Row(
        children: [
          if (!isSmallScreen) _Sidebar(controller: controller),
          if (controller.selectedIndex == 0)
            Expanded(
              child: Center(
                child: _MainScreen(
                  controller: controller,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MainScreen extends StatelessWidget {
  const _MainScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return const UsersTab();
          case 1:
            return CreateUserTab(
              sidebarController: controller,
            );
          case 2:
            return const StorageTab();
          default:
            return Container();
        }
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    super.key,
    required SidebarXController controller,
  }) : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/default-avatar.png'),
          ),
        );
      },
      items: [
        const SidebarXItem(
          icon: Icons.people,
          label: 'Users',
        ),
        const SidebarXItem(
          icon: Icons.person_add_alt_sharp,
          label: 'Create User',
        ),
        const SidebarXItem(
          icon: Icons.storage,
          label: 'Storage',
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Logout',
          selectable: false,
          onTap: () {
            context.read<AuthBloc>().add(SignOutUserStarted());
            context.goNamed(SignInScreen.name);
          },
        ),
      ],
    );
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);

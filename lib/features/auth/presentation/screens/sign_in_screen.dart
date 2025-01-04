import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner_web/features/auth/core/exceptions/auth_execptions.dart';
import 'package:document_scanner_web/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  static String name = 'Sign In';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool enableButton = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkIfValid);
    passwordController.addListener(_checkIfValid);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _checkIfValid() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() => enableButton = true);
    } else {
      setState(() => enableButton = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthSuccess) {
          AnimatedSnackBar.material(
            authState.message,
            type: AnimatedSnackBarType.success,
            duration: const Duration(seconds: 5),
            mobileSnackBarPosition: MobileSnackBarPosition.top,
          ).show(context);

          context.goNamed(HomeScreen.name);
        } else if (authState is AuthFail) {
          AuthException e = authState.exception;

          AnimatedSnackBar.material(
            e.message,
            type: AnimatedSnackBarType.error,
            duration: const Duration(seconds: 5),
            mobileSnackBarPosition: MobileSnackBarPosition.top,
          ).show(context);
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color
                borderRadius: BorderRadius.circular(16), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    blurRadius: 8, // Spread of the shadow
                    offset: const Offset(0, 2), // Offset of the shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Administrator',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: enableButton
                          ? () {
                              if (emailController.text != "admin@admin.com") {
                                AnimatedSnackBar.material(
                                  "Invalid user.",
                                  type: AnimatedSnackBarType.error,
                                  duration: const Duration(seconds: 5),
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                              } else {
                                context.read<AuthBloc>().add(
                                      SignInUserStarted(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner_web/base/widgets/base_text_button.dart';
import 'package:document_scanner_web/base/widgets/base_textfield.dart';
import 'package:document_scanner_web/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/get_users_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sidebarx/sidebarx.dart';

class CreateUserTab extends StatefulWidget {
  final SidebarXController sidebarController;

  const CreateUserTab({
    super.key,
    required this.sidebarController,
  });

  @override
  State<CreateUserTab> createState() => _CreateUserTabState();
}

class _CreateUserTabState extends State<CreateUserTab> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool enableButton = false;

  PlatformFile? pickedFile;

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_checkIfValid);
    lastNameController.addListener(_checkIfValid);
    emailController.addListener(_checkIfValid);
    passwordController.addListener(_checkIfValid);
    confirmPasswordController.addListener(_checkIfValid);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkIfValid() {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        pickedFile != null) {
      setState(() => enableButton = true);
    } else {
      setState(() => enableButton = false);
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });

    _checkIfValid();
  }

  void reset() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      pickedFile = null;
      enableButton = false;
    });
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
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);

          context.read<GetUsersBloc>().add(GetUsersStarted());

          reset();
          widget.sidebarController.selectIndex(0);
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 8,
              ), //
              Image.asset(
                'assets/images/logo.jpg', // Path to your logo image
                height: 40, // Adjust height as needed
              ),
              const SizedBox(
                width: 8,
              ), // Add spacing between the logo and title
              const Expanded(
                child: Text(
                  "ADMIN CONSOLE FOR MOBILE DOCUMENT SCANNER APP FOR PSU",
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  if (pickedFile != null)
                    Center(
                      child: InkWell(
                        onTap: selectFile,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 80.0,
                          backgroundImage: pickedFile != null
                              ? MemoryImage(pickedFile!.bytes!)
                              : null,
                        ),
                      ),
                    ),
                  if (pickedFile == null)
                    Center(
                      child: BaseTextButton(
                        text: "Select Profile Image",
                        onPressed: selectFile,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(59),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                        ),
                      ),
                    ),
                  BaseTextField(
                    label: "First Name",
                    hint: "John",
                    type: BaseTextFieldType.text,
                    controller: firstNameController,
                  ),
                  BaseTextField(
                    label: "Last Name",
                    hint: "Doe",
                    type: BaseTextFieldType.text,
                    controller: lastNameController,
                  ),
                  BaseTextField(
                    label: "Email",
                    hint: "john.doe@gmail.com",
                    type: BaseTextFieldType.text,
                    controller: emailController,
                  ),
                  BaseTextField(
                    label: "Password",
                    hint: "*******",
                    type: BaseTextFieldType.text,
                    obscureText: true,
                    controller: passwordController,
                  ),
                  BaseTextField(
                    label: "Confirm Password",
                    hint: "*******",
                    type: BaseTextFieldType.text,
                    obscureText: true,
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: BaseTextButton(
                      text: 'Create User',
                      onPressed: enableButton
                          ? () {
                              context.read<AuthBloc>().add(
                                    SignUpUserStarted(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                      profileImage: pickedFile,
                                    ),
                                  );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

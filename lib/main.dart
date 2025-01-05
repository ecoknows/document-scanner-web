import 'dart:io';

import 'package:document_scanner_web/app.dart';
import 'package:document_scanner_web/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/delete_user_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/get_all_scanned_documents_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/get_users_bloc.dart';
import 'package:document_scanner_web/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => GetUsersBloc()),
        BlocProvider(create: (_) => DeleteUserBloc()),
        BlocProvider(create: (_) => GetScannedDocumentsBloc()),
        BlocProvider(create: (_) => GetAllScannedDocumentsBloc()),
      ],
      child: const App(),
    );
  }
}

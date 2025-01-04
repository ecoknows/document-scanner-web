import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:document_scanner_web/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'get_users_event.dart';
part 'get_users_state.dart';

class GetUsersBloc extends Bloc<GetUsersEvent, GetUsersState> {
  GetUsersBloc() : super(GetUsersInitial()) {
    on<GetUsersStarted>(_getUsers);
  }

  Future<void> _getUsers(
    GetUsersStarted event,
    Emitter<GetUsersState> emit,
  ) async {
    final url = Uri.parse(
        'https://us-central1-document-scanner-35bdb.cloudfunctions.net/getAllUsers');
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      List<User> users = jsonList.map((json) => User.fromJson(json)).toList();

      emit(GetUsersSuccess(users: users));
    } else {
      emit(GetUsersFail());
    }
  }
}

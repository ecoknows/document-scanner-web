import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'delete_user_event.dart';
part 'delete_user_state.dart';

class DeleteUserBloc extends Bloc<DeleteUserEvent, DeleteUserState> {
  DeleteUserBloc() : super(DeleteUserInitial()) {
    on<DeleteUserStarted>(_deleteUser);
  }

  Future<void> _deleteUser(
    DeleteUserStarted event,
    Emitter<DeleteUserState> emit,
  ) async {
    final url = Uri.parse(
      'https://us-central1-document-scanner-35bdb.cloudfunctions.net/deleteUser',
    );

    emit(DeleteUserInProgress());

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'uid': event.uid}),
      );

      if (response.statusCode == 200) {
        emit(DeleteUserSuccess());
      } else {
        emit(DeleteUserFail());
      }
    } catch (e) {
      emit(DeleteUserFail());
    }
  }
}

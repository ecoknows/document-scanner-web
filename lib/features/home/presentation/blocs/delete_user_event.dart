part of 'delete_user_bloc.dart';

sealed class DeleteUserEvent extends Equatable {}

final class DeleteUserStarted extends DeleteUserEvent {
  final String uid;

  DeleteUserStarted({
    required this.uid,
  });

  @override
  List<Object> get props => [uid];
}

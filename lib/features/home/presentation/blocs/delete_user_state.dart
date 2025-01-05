part of 'delete_user_bloc.dart';

sealed class DeleteUserState extends Equatable {}

final class DeleteUserInitial extends DeleteUserState {
  DeleteUserInitial();

  @override
  List<Object> get props => [];
}

final class DeleteUserInProgress extends DeleteUserState {
  DeleteUserInProgress();

  @override
  List<Object> get props => [];
}

final class DeleteUserSuccess extends DeleteUserState {
  DeleteUserSuccess();

  @override
  List<Object> get props => [];
}

final class DeleteUserFail extends DeleteUserState {
  DeleteUserFail();

  @override
  List<Object> get props => [];
}

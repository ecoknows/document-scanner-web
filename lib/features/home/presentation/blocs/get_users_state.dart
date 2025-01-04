part of 'get_users_bloc.dart';

sealed class GetUsersState extends Equatable {}

final class GetUsersInitial extends GetUsersState {
  GetUsersInitial();

  @override
  List<Object> get props => [];
}

final class GetUsersInProgress extends GetUsersState {
  GetUsersInProgress();

  @override
  List<Object> get props => [];
}

final class GetUsersSuccess extends GetUsersState {
  final List<User> users;

  GetUsersSuccess({
    required this.users,
  });

  @override
  List<Object> get props => [users];
}

final class GetUsersFail extends GetUsersState {
  GetUsersFail();

  @override
  List<Object> get props => [];
}

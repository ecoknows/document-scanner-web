part of 'get_users_bloc.dart';

sealed class GetUsersEvent extends Equatable {}

final class GetUsersStarted extends GetUsersEvent {
  GetUsersStarted();

  @override
  List<Object?> get props => [];
}

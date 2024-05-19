part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginForm extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final String accessToken;

  LoginSuccess(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

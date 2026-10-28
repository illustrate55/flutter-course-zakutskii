import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}
class AuthStarted extends AuthEvent {}
class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInRequested(this.email, this.password);
}
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  const SignUpRequested(this.email, this.password);
}
class SignOutRequested extends AuthEvent {}
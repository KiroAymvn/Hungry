import 'package:hungry/features/auth/data/user_model.dart';

/// All possible states for the Auth feature.
abstract class AuthState {}

/// The initial state before any action is taken.
class AuthInitial extends AuthState {}

/// Shown while waiting for an API call to finish.
class AuthLoading extends AuthState {}

/// Emitted when login, register, or profile fetch is successful.
class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}

/// Emitted when any auth operation fails.
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

/// Emitted when the user chose "Continue as Guest".
class AuthGuest extends AuthState {}

/// Emitted after a successful logout.
class AuthLoggedOut extends AuthState {}

/// Emitted while the update-profile API call is running.
class AuthUpdateLoading extends AuthState {
  final UserModel currentUser; // keep showing the old data while updating
  AuthUpdateLoading(this.currentUser);
}

/// Emitted after a successful profile update.
class AuthUpdateSuccess extends AuthState {
  final UserModel user;
  AuthUpdateSuccess(this.user);
}

/// Emitted while the logout API call is running.
class AuthLogoutLoading extends AuthState {}

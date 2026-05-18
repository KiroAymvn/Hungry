import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/features/auth/cubit/auth_state.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';

/// AuthCubit handles all authentication business logic.
/// It talks to AuthRepo and emits states that the UI listens to.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  // ─────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.login(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Login failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // REGISTER
  // ─────────────────────────────────────────────
  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.register(
        name: name,
        email: email,
        password: password,
      );
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // AUTO LOGIN (used on splash screen)
  // ─────────────────────────────────────────────
  Future<void> autoLogin() async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.autoLogin();
      if (_authRepo.isGuest) {
        emit(AuthGuest());
      } else if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial()); // no token → show login screen
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  // ─────────────────────────────────────────────
  // GET PROFILE
  // ─────────────────────────────────────────────
  Future<void> getProfile() async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.getProfileData();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthGuest());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // UPDATE PROFILE
  // ─────────────────────────────────────────────
  Future<void> updateProfile({
    String? name,
    String? email,
    String? address,
    String? image,
    String? visa,
    required UserModel currentUser,
  }) async {
    // show spinner but keep current data visible
    emit(AuthUpdateLoading(currentUser));
    try {
      final user = await _authRepo.updateProfileData(
        name: name,
        email: email,
        address: address,
        image: image,
        visa: visa,
      );
      if (user != null) {
        emit(AuthUpdateSuccess(user));
      } else {
        emit(AuthError('Update failed.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────
  Future<void> logout() async {
    emit(AuthLogoutLoading());
    try {
      await _authRepo.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // CONTINUE AS GUEST
  // ─────────────────────────────────────────────
  Future<void> continueAsGuest() async {
    emit(AuthLoading());
    try {
      await _authRepo.continueAsAGuest();
      emit(AuthGuest());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

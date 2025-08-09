import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- AUTH STATE --- //
sealed class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}

// --- AUTH NOTIFIER --- //
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._auth) : super(const AuthStateLoading()) {
    // Listen to Firebase auth changes to keep state in sync
    _auth.authStateChanges().listen(_firebaseUserChanged);
  }

  final FirebaseAuth _auth;

  void _firebaseUserChanged(User? user) {
    if (user == null) {
      state = const AuthStateUnauthenticated();
    } else {
      state = AuthStateAuthenticated(user);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = const AuthStateLoading();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // state will update from authStateChanges listener
    } on FirebaseAuthException catch (e) {
      state = AuthStateError(e.message ?? 'Login failed');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      state = const AuthStateLoading();
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      state = AuthStateError(e.message ?? 'Sign-up failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(FirebaseAuth.instance);
});

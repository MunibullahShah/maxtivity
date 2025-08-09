// ignore_for_file: unused_import
// (user_model import currently unused; future enhancement)
import 'package:maxtivity/utils/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class SignUpRepository {
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await AuthService.instance.signUp(
        email: email,
        password: password,
      );
      // Could save name in Firestore later.
      return user?.uid ?? "";
    } on FirebaseAuthException catch (e) {
      getErrorSnackbar(
        title: "Auth Error",
        message: e.message ?? "Unknown error",
      );
      return "";
    }
  }
}

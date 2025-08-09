import 'package:firebase_auth/firebase_auth.dart';
import 'package:maxtivity/utils/services/auth_service.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class LoginRepository {
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await AuthService.instance.signIn(
        email: email,
        password: password,
      );
      final token = await user?.getIdToken();
      return token ?? "";
    } on FirebaseAuthException catch (e) {
      getErrorSnackbar(
        title: "Auth Error",
        message: e.message ?? "Unknown error",
      );
      return "";
    } catch (_) {
      getErrorSnackbar(title: "Error", message: "Login failed");
      return "";
    }
  }
}

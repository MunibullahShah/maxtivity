import 'package:firebase_auth/firebase_auth.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class SignUpRepository {
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Optionally set display name
      if (name.isNotEmpty) {
        await credential.user?.updateDisplayName(name);
      }

      final token = await credential.user?.getIdToken();
      return token ?? "";
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email already in use';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed';
          break;
        case 'weak-password':
          message = 'Weak password';
          break;
      }
      getErrorSnackbar(title: 'Error', message: message);
      return "";
    } catch (e) {
      getErrorSnackbar(title: 'Error', message: 'Something went wrong');
      return "";
    }
  }
}

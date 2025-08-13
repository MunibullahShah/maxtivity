import 'package:firebase_auth/firebase_auth.dart';
import 'package:maxtivity/utils/ui/snackbar.dart';

class LoginRepository {
  Future<String> login(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final token = await credential.user?.getIdToken();
      return token ?? "";
    } on FirebaseAuthException catch (e) {
      String message = 'Authentication failed';
      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'User disabled';
          break;
        case 'user-not-found':
          message = 'No user found for that email';
          break;
        case 'wrong-password':
          message = 'Wrong password provided';
          break;
        case 'too-many-requests':
          message = 'Too many attempts, try again later';
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

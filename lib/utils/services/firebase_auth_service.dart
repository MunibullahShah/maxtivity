import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseAuthService extends GetxController {
  static FirebaseAuthService get to => Get.find();

  final _auth = FirebaseAuth.instance;

  Rx<User?> currentUser = Rx<User?>(null);

  bool get isLoggedIn => currentUser.value != null;
  String? get uid => currentUser.value?.uid;

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_auth.authStateChanges());
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Sign-in failed';
    }
  }

  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Sign-up failed';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

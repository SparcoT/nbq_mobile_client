import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<User> signIn({String email, String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found')
        throw ('No user found for that email.');
      else if (e.code == 'wrong-password')
        throw ('Wrong password provided for that user.');
      else
        throw (e.code);
    }
  }
}

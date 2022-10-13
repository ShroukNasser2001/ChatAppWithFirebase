import 'package:firebase_auth/firebase_auth.dart';

import 'Database_Service.dart';
import 'Functions.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerUserWithEmailandPassword(
      String firstName, String lastName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid)
            .savingUserData(firstName, lastName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await Functions.saveUserLoggedInStatus(false);
      await Functions.saveUserEmail("");
      await Functions.saveUserFirstName("");
      await Functions.saveUserLastName("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}

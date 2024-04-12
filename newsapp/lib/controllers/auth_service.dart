import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String _verificationId = "";

  // To send an OTP to the user
  static Future<void> sendOtp({
    required String phoneNumber,
    required Function onError,
    required Function onCodeSent,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        timeout: Duration(seconds: 30),
        phoneNumber: "+91$phoneNumber",
        verificationCompleted: (phoneAuthCredential) async {
          // Auto-retrieval or instant verification is supported, proceed to verification.
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) async {
          // Verification failed, handle error.
          onError("Verification failed. ${error.code}");
        },
        codeSent: (verificationId, forceResendingToken) async {
          // Handle the case where the code is successfully sent to the user's device.
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          // Auto-retrieval timeout, handle error.
          onError("Verification timeout.");
        },
      );
    } catch (e) {
      // Handle any unexpected errors.
      onError("An unexpected error occurred.");
    }
  }

  // Verify the OTP code and login
  static Future<String> loginWithOtp({required String otp}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Successful login
        return "Success";
      } else {
        // Login failed
        return "Error in OTP login";
      }
    } on FirebaseAuthException catch (e) {
      // Firebase authentication exception, handle error.
      return e.message ?? "An error occurred";
    } catch (e) {
      // Other exceptions, handle error.
      return "An error occurred";
    }
  }

  // Logout the user
  static Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Check whether the user is logged in or not
  static Future<bool> isLoggedIn() async {
    final User? user = _firebaseAuth.currentUser;
    return user != null;
  }
}

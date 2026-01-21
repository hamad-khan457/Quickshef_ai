import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../config/app_constants.dart';

/// Authentication service handling user registration, login, and logout
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Register new user with email and password
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user account
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      // Update display name
      await user.updateDisplayName(name);

      // Create user document in Firestore
      final UserModel userModel = UserModel(
        uid: user.uid,
        name: name.trim(),
        email: email.trim(),
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(user.uid)
          .set(userModel.toFirestore());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Sign in failed');
      }

      // Fetch user data from Firestore
      final DocumentSnapshot userDoc = await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot userDoc = await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw Exception('Failed to fetch user data: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    required String name,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.firestoreUsers)
          .doc(uid)
          .update({'name': name});

      await _auth.currentUser?.updateDisplayName(name);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Delete user document
      await _firestore
          .collection(AppConstants.COLLECTION_USERS)
          .doc(user.uid)
          .delete();

      // Delete user account
      await user.delete();
    } catch (e) {
      throw Exception('Account deletion failed: ${e.toString()}');
    }
  }

  /// Handle Firebase Authentication exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak';
      case 'email-already-in-use':
        return 'An account already exists for this email';
      case 'invalid-email':
        return 'The email address is invalid';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Authentication error: ${e.message}';
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}

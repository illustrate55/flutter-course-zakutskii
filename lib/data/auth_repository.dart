import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    }
  }

  Future<void> signOut() async => await _firebaseAuth.signOut();

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found': return 'Пользователь с таким email не найден.';
      case 'wrong-password': return 'Неверный пароль.';
      case 'email-already-in-use': return 'Этот email уже зарегистрирован.';
      case 'weak-password': return 'Слишком короткий пароль (минимум 6 символов).';
      case 'invalid-email': return 'Некорректный email.';
      default: return 'Ошибка авторизации. Попробуйте еще раз.';
    }
  }
}
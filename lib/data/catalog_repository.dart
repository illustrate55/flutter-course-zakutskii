import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/drink.dart';

class CatalogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Drink>> getDrinksStream() {
    return _firestore.collection('drinks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Drink.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<String>> getFavoriteIdsStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null || doc.data()!['favorites'] == null) return [];
      return List<String>.from(doc.data()!['favorites']);
    });
  }

  Future<void> addDrink(Drink drink) async {
    await _firestore.collection('drinks').add(drink.toFirestore());
  }

  Future<void> toggleFavorite(String uid, String drinkId, bool isCurrentlyFavorite) async {
    final userRef = _firestore.collection('users').doc(uid);
    if (isCurrentlyFavorite) {
      await userRef.update({'favorites': FieldValue.arrayRemove([drinkId])});
    } else {
      await userRef.set({'favorites': FieldValue.arrayUnion([drinkId])}, SetOptions(merge: true));
    }
  }
}
import 'package:lab2/entities/city_entity.dart';
import 'package:lab2/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAppDataHandler {
  static final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  static Future<void> registerUserInDatabase(String id, UserEntity user) async {
    await _databaseReference.child('users').child(id).set(user.toJson());
  }

  static Future<UserEntity?> getUserInfo() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final userDataSnapshot =
        await _databaseReference.child('users').child(user!.uid).once();
    final data =
        Map<String, dynamic>.from(userDataSnapshot.snapshot.value as Map);
    final UserEntity userData = UserEntity.fromJson(data);
    return userData;
  }

  static Future<void> updateUserInfo(
      String name,
      String surname,
      int age,
      String dateOfBirth,
      String address,
      String male,
      String phoneNumber,
      String favCity,
      String favCountry) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final userData = {
      'name': name,
      'surname': surname,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'male': male,
      'age': age,
      'phoneNumber': phoneNumber,
      'favCity': favCity,
      'favCountry': favCountry,
    };

    await _databaseReference.child('users').child(user!.uid).update(userData);
  }

  static Future<List<CityEntity>> getAllCities() async {
    final allBooksSnapshot = await _databaseReference.child('cities').once();
    final allData =
        Map<String, dynamic>.from(allBooksSnapshot.snapshot.value as Map);
    final List<CityEntity> books =
        CityEntity.getCityList(allData.values.toList());
    return books;
  }

  static Future<List<CityEntity>> getFavorites() async {
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    final User? currentUser = authInstance.currentUser;
    var userSnapshot =
        await _databaseReference.child('users').child(currentUser!.uid).once();
    final Map<String, dynamic> userData =
        Map<String, dynamic>.from(userSnapshot.snapshot.value as Map);
    if (userData.containsKey('favorites')) {
      if (userData['favorites'] != null && userData['favorites'].isNotEmpty) {
        var favoritePostsMap = userData['favorites']
            ?.map((key, value) => MapEntry(key as String, value as dynamic));
        List<CityEntity> favoriteCities =
            CityEntity.getCityList(favoritePostsMap.values.toList());
        return favoriteCities;
      }
    }
    return [];
  }

  static Future<bool> addToFavorites(CityEntity city) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    try {
      await _databaseReference
          .child('users')
          .child(user!.uid)
          .child('favorites')
          .push()
          .set(city.toJson());
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<bool> removeFromFavorites(CityEntity city) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    try {
      final userDataSnapshot =
          await _databaseReference.child('users').child(user!.uid).once();
      final data =
          Map<String, dynamic>.from(userDataSnapshot.snapshot.value as Map);
      if (data.containsKey('favorites')) {
        var favoritePosts = data['favorites'] != null
            ? Map<String, dynamic>.from(data['favorites'])
            : <String, dynamic>{};
        favoritePosts.removeWhere((key, value) => city == value);
        await _databaseReference
            .child('users')
            .child(user.uid)
            .update({'favorites': favoritePosts});
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<bool> checkIfInFavorites(CityEntity city) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final userDataSnapshot =
        await _databaseReference.child('users').child(user!.uid).once();
    final data =
        Map<String, dynamic>.from(userDataSnapshot.snapshot.value as Map);

    if (data.containsKey('favorites')) {
      var favoritePosts = data['favorites']
          ?.map((key, value) => MapEntry(key as String, value as dynamic));
      List<CityEntity> books =
          CityEntity.getCityList(favoritePosts.values.toList());
      return books.contains(city);
    }
    return false;
  }
}

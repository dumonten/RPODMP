class UserEntity {
  late String name;
  late String surname;
  late String dateOfBirth;
  late String address;
  late String email;
  late String male;
  late int age;
  late String phoneNumber;
  late String favCity;
  late String favCountry;
  late List<String>? favorites;

  UserEntity(
      this.name,
      this.surname,
      this.dateOfBirth,
      this.address,
      this.email,
      this.male,
      this.age,
      this.phoneNumber,
      this.favCity,
      this.favCountry);

   UserEntity.fromEmail(this.email) {
    name = "";
    surname = "";
    dateOfBirth = "";
    address = "";
    male = "";
    age = 0;
    phoneNumber = "";
    favCity = "";
    favCountry = "";
    favorites = [];
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "surname": surname,
    "dateOfBirth": dateOfBirth,
    "address": address,
    "email": email,
    "male": male,
    "age": age,
    "phoneNumber": phoneNumber,
    "favCity": favCity,
    "favCountry": favCountry,
    "favorites": favorites ?? [], // Используйте оператор ?? для предотвращения ошибок, если favorites равно null
  };

  static UserEntity fromJson(Map<String, dynamic> data) {
    return UserEntity(
        data['name'],
        data['surname'],
        data['dateOfBirth'],
        data['address'],
        data['email'],
        data['male'],
        data['age'],
        data['phoneNumber'],
        data['favCity'],
        data['favCountry']);
  }
}

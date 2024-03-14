class CityEntity {
  late String id;
  late String name;
  late String country;
  late String description;
  late int yearOfFoundation;
  late List<String> imageUrls;

  CityEntity(this.id, this.name, this.country, this.description,
      this.yearOfFoundation, this.imageUrls);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "country": country,
        "yearOfFoundation": yearOfFoundation,
        "imageUrls": imageUrls
      };

  static getCityList(List data) {
    List<CityEntity> result = [];
    for (final city in data) {
      List<String> imageUrls =
          (city['imageUrls'] as List).map((e) => e as String).toList();
      result.add(CityEntity(city['id'], city['name'], city['description'],
          city['country'], city['yearOfFoundation'], imageUrls));
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is CityEntity) {
      return other.id == id;
    } else if (other is Map<Object?, Object?>) {
      Map<String, dynamic> temp =
          other.map((key, value) => MapEntry(key.toString(), value));
      return temp['id'] == id;
    }

    return false;
  }

  @override
  int get hashCode => name.hashCode ^ country.hashCode;
}

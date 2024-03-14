import 'package:lab2/entities/city_entity.dart';

class UtilFunctions {
  static checkListType(List list) {
    if (list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static findElement(List<CityEntity> list, CityEntity cityEntity) {
    for (final city in list) {
      if (city.name == cityEntity.name && city.country == cityEntity.country) {
        return true;
      }
    }
    return false;
  }
}

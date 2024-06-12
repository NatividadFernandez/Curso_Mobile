import 'package:pet_adopt_app/model/common_class.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';

class PetsRemoteModel {
  List<Pet> pets;
  Pagination pagination;

  PetsRemoteModel({
    required this.pets,
    required this.pagination,
  });

  factory PetsRemoteModel.fromMap(Map<String, dynamic> json) => PetsRemoteModel(
        pets: List<Pet>.from(json["animals"].map((x) => Pet.fromMap(x))),
        pagination: Pagination.fromMap(json["pagination"]),
      );

  Map<String, dynamic> toMap() => {
        "animals": List<dynamic>.from(pets.map((x) => x.toMap())),
        "pagination": pagination.toMap(),
      };
}

class PetRemoteModel {
  Pet pet;

  PetRemoteModel({
    required this.pet,
  });

  factory PetRemoteModel.fromMap(Map<String, dynamic> json) => PetRemoteModel(
        pet: Pet.fromMap(json["animal"]),
      );

  Map<String, dynamic> toMap() => {
        "animal": pet.toMap(),
      };
}

class PetsTypesRemoteModel {
  List<PetType> types;

  PetsTypesRemoteModel({
    required this.types,
  });

  factory PetsTypesRemoteModel.fromMap(Map<String, dynamic> json) =>
      PetsTypesRemoteModel(
        types: List<PetType>.from(json["types"].map((x) => PetType.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "types": List<dynamic>.from(types.map((x) => x.toMap())),
      };
}

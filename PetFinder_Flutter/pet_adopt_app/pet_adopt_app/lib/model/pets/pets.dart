import 'package:pet_adopt_app/model/common_class.dart';

class PetsNetworkResponse {
  List<Pet> pets;
  Pagination pagination;

  PetsNetworkResponse({
    required this.pets,
    required this.pagination,
  });
}

class PetNetworkResponse {
  Pet pet;

  PetNetworkResponse({
    required this.pet,
  });
}

class Pet {
  int id;
  String organizationId;
  String url;
  String type;
  Breeds? breeds;
  String age;
  String gender;
  String size;
  String name;
  String? description;
  List<Photo>? photos;
  Contact? contact;
  bool isFavorite;

  Pet({
    required this.id,
    required this.organizationId,
    required this.url,
    required this.type,
    required this.breeds,
    required this.age,
    required this.gender,
    required this.size,
    required this.name,
    required this.description,
    required this.photos,
    required this.contact,
    required this.isFavorite,
  });

  List<Characteristic> get characteristics {
    return [
      Characteristic(id: 1, title: "size", label: size),
      Characteristic(id: 2, title: "age", label: age),
      Characteristic(id: 3, title: "gender", label: gender),
    ];
  }

  factory Pet.fromMap(Map<String, dynamic> json) => Pet(
        id: json["id"],
        organizationId: json["organization_id"],
        url: json["url"],
        type: json["type"],
        breeds: json["breeds"] != null ? Breeds.fromMap(json["breeds"]) : null,
        age: json["age"],
        gender: json["gender"],
        size: json["size"],
        name: json["name"],
        description: json["description"],
        photos: (json["photos"] as List<dynamic>?)
            ?.map((x) => Photo.fromMap(x))
            .toList(),
        contact:
            json["contact"] != null ? Contact.fromMap(json["contact"]) : null,
        isFavorite: json["isFavorite"] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "organization_id": organizationId,
        "url": url,
        "type": type,
        "breeds": breeds?.toMap(),
        "age": age,
        "gender": gender,
        "size": size,
        "name": name,
        "description": description,
        "photos": photos?.map((x) => x.toMap()),
        "contact": contact?.toMap(),
        "isFavorite": isFavorite ? 1 : 0,
      };
}

class Breeds {
  String primary;

  Breeds({
    required this.primary,
  });

  factory Breeds.fromMap(Map<String, dynamic> json) => Breeds(
        primary: json["primary"],
      );

  Map<String, dynamic> toMap() => {
        "primary": primary,
      };
}

class PetsTypesNetworkResponse {
  List<PetType> types;

  PetsTypesNetworkResponse({
    required this.types,
  });
}

class PetType {
  String name;

  PetType({
    required this.name,
  });

  factory PetType.fromMap(Map<String, dynamic> json) => PetType(
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
      };
}

class PetDB {
  int id;
  String organizationId;
  String url;
  String type;
  String? breeds;
  String age;
  String gender;
  String size;
  String name;
  String? description;
  String? photos;
  String? email;
  String? phone;
  String? city;
  bool isFavorite;

  PetDB({
    required this.id,
    required this.organizationId,
    required this.url,
    required this.type,
    required this.breeds,
    required this.age,
    required this.gender,
    required this.size,
    required this.name,
    required this.description,
    required this.photos,
    required this.email,
    required this.phone,
    required this.city,
    required this.isFavorite,
  });

  factory PetDB.fromMap(Map<String, dynamic> map) {
    return PetDB(
      id: map['id'],
      organizationId: map['organization_id'],
      url: map['url'],
      type: map['type'],
      breeds: map['breeds'],
      age: map['age'],
      gender: map['gender'],
      size: map['size'],
      name: map['name'],
      description: map['description'],
      photos: map['photos'],
      email: map['email'],
      phone: map['phone'],
      city: map['city'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "organization_id": organizationId,
        "url": url,
        "type": type,
        "breeds": breeds,
        "age": age,
        "gender": gender,
        "size": size,
        "name": name,
        "description": description,
        "photos": photos,
        "email": email,
        "phone": phone,
        "city": city,
        "isFavorite": isFavorite ? 1 : 0,
      };

  factory PetDB.fromPet(Pet pet) => PetDB(
        id: pet.id,
        organizationId: pet.organizationId,
        url: pet.url,
        type: pet.type,
        breeds: pet.breeds?.primary,
        age: pet.age,
        gender: pet.gender,
        size: pet.size,
        name: pet.name,
        description: pet.description,
        photos: pet.photos?.firstOrNull?.full ?? "",
        email: pet.contact?.email,
        phone: pet.contact?.phone,
        city: pet.contact?.address?.city,
        isFavorite: pet.isFavorite,
      );

  Pet toPet() {
    return Pet(
      id: id,
      organizationId: organizationId,
      url: url,
      type: type,
      breeds: Breeds(primary: breeds ?? ""),
      age: age,
      gender: gender,
      size: size,
      name: name,
      description: description,
      photos: photos!.isNotEmpty ? [Photo(full: photos)] : [],
      contact: Contact(
        email: email,
        phone: phone,
        address: Address(city: city),
      ),
      isFavorite: isFavorite,
    );
  }
}

class Characteristic {
  final int id;
  final String title;
  final String label;

  Characteristic({required this.id, required this.title, required this.label});
}

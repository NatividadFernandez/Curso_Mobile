import 'package:pet_adopt_app/model/pets/pets.dart';

abstract class PetsRepository {
  Future<PetsNetworkResponse> getPets(String type, String page);
  Future<Pet> getPet(int petId);
  Future<List<PetType>> getPetTypes();

  Future<List<Pet>> getPetsFavorites();
  Future addPetFavorite(Pet pet);
  Future deletePetFavorite(Pet pet);

  Future<bool> isFavorite(Pet pet);
}

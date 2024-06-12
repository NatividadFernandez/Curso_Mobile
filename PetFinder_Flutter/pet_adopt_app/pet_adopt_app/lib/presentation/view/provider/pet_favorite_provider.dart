import 'package:flutter/material.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';

class PetFavoriteProvider extends ChangeNotifier {
  List<Pet> _petFavoriteList = List.empty(growable: true);
  bool _isFavorite = false;

  List<Pet> get petFavoriteList => _petFavoriteList;
  bool get isFavorite => _isFavorite;

  newFavoriteList(List<Pet> oldPetFavoriteList) {
    _petFavoriteList = oldPetFavoriteList;
    notifyListeners();
  }

  addPetFavorite(Pet pet) {
    _petFavoriteList.add(pet);
    notifyListeners();
  }

  deletePetFavorite(Pet pet) {
    _petFavoriteList.removeWhere((item) => item.id == pet.id);
    notifyListeners();
  }

  isPetFavorite(bool isFavorite) {
    _isFavorite = isFavorite;
    notifyListeners();
  }
}

// ignore_for_file: void_checks

import 'dart:async';

import 'package:pet_adopt_app/domain/pets_repository.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';
import 'package:pet_adopt_app/presentation/base/base_view_model.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';

typedef PetsState = ResourceState<PetsNetworkResponse>;
typedef PetState = ResourceState<Pet>;
typedef PetsTypesState = ResourceState<List<PetType>>;
typedef PetsFavoritesState = ResourceState<List<Pet>>;
typedef PetOperationState = ResourceState<void>;
typedef FavoriteState = ResourceState<bool>;

class PetsViewModel extends BaseViewModel {
  final PetsRepository _petsRepository;

  final StreamController<PetsState> getPetsState = StreamController();

  final StreamController<PetState> getPetState = StreamController();

  final StreamController<PetsTypesState> getPetsTypesState = StreamController();

  final StreamController<PetsFavoritesState> getPetsFavoritesState =
      StreamController();

  final StreamController<PetOperationState> addPetsFavoritesState =
      StreamController();

  final StreamController<PetOperationState> deletePetFavoritesState =
      StreamController();

  final StreamController<FavoriteState> isPetFavoriteState = StreamController();

  PetsViewModel({required PetsRepository petsRepository})
      : _petsRepository = petsRepository;

  fetchGetPets(String type, String page) {
    getPetsState.add(ResourceState.loading());

    _petsRepository
        .getPets(type, page)
        .then((value) => getPetsState.add(ResourceState.success(value)))
        .catchError((error) => getPetsState.add(ResourceState.error(error)));
  }

  fetchGetPet(int petId) {
    getPetState.add(ResourceState.loading());

    _petsRepository
        .getPet(petId)
        .then((value) => getPetState.add(ResourceState.success(value)))
        .catchError((error) => getPetState.add(ResourceState.error(error)));
  }

  fetchGetPetsTypes() {
    getPetsTypesState.add(ResourceState.loading());

    _petsRepository
        .getPetTypes()
        .then((value) => getPetsTypesState.add(ResourceState.success(value)))
        .catchError(
            (error) => getPetsTypesState.add(ResourceState.error(error)));
  }

  fetchGetPetsFavorites() {
    getPetsFavoritesState.add(ResourceState.loading());

    _petsRepository
        .getPetsFavorites()
        .then(
            (value) => getPetsFavoritesState.add(ResourceState.success(value)))
        .catchError(
            (error) => getPetsFavoritesState.add(ResourceState.error(error)));
  }

  addPetFavorites(Pet pet) {
    addPetsFavoritesState.add(ResourceState.loading());

    _petsRepository
        .addPetFavorite(pet)
        .then((value) => addPetsFavoritesState.add(ResourceState.success(true)))
        .catchError(
            (error) => addPetsFavoritesState.add(ResourceState.error(error)));
  }

  deletePetFavorites(Pet pet) {
    deletePetFavoritesState.add(ResourceState.loading());

    _petsRepository
        .deletePetFavorite(pet)
        .then((value) =>
            deletePetFavoritesState.add(ResourceState.success(false)))
        .catchError(
            (error) => deletePetFavoritesState.add(ResourceState.error(error)));
  }

  isPetFavorite(Pet pet) {
    isPetFavoriteState.add(ResourceState.loading());

    _petsRepository
        .isFavorite(pet)
        .then((value) => isPetFavoriteState.add(ResourceState.success(value)))
        .catchError(
            (error) => isPetFavoriteState.add(ResourceState.error(error)));
  }

  @override
  void dispose() {
    getPetsState.close();
    getPetState.close();
    getPetsTypesState.close();
    isPetFavoriteState.close();
    addPetsFavoritesState.close();
    deletePetFavoritesState.close();
    getPetsFavoritesState.close();
  }
}

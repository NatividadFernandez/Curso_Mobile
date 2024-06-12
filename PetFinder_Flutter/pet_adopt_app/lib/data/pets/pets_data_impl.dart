import 'package:pet_adopt_app/data/pets/local/pets_local_impl.dart';
import 'package:pet_adopt_app/data/pets/remote/mapper/pets_remote_mapper.dart';
import 'package:pet_adopt_app/data/pets/remote/pets_remote_impl.dart';
import 'package:pet_adopt_app/data/token/local/token_local_impl.dart';
import 'package:pet_adopt_app/domain/pets_repository.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';

class PetsDataImpl extends PetsRepository {
  final PetsRemoteImpl _remoteImpl;
  final PetsLocalImpl _localImpl;
  final TokenLocalImpl _tokenLocalImpl;

  PetsDataImpl(
      {required PetsRemoteImpl remoteImpl,
      required PetsLocalImpl localImpl,
      required TokenLocalImpl tokenLocalImpl})
      : _remoteImpl = remoteImpl,
        _tokenLocalImpl = tokenLocalImpl,
        _localImpl = localImpl;

  @override
  Future<PetsNetworkResponse> getPets(String type, String page) async {
    final token = await _tokenLocalImpl.loadToken();
    final remotePets = await _remoteImpl.getPets(token, type, page);
    return PetsRemoteMapper.fromRemote(remotePets);
  }

  @override
  Future<Pet> getPet(int petId) async {
    final token = await _tokenLocalImpl.loadToken();
    return await _remoteImpl.getPet(token, petId);
  }

  @override
  Future<List<PetType>> getPetTypes() async {
    final token = await _tokenLocalImpl.loadToken();
    return await _remoteImpl.getPetTypes(token);
  }

  @override
  Future<void> addPetFavorite(Pet pet) async {
    await _localImpl.addPetFavorites(pet);
  }

  @override
  Future<void> deletePetFavorite(Pet pet) async {
    await _localImpl.deletePetFavorites(pet);
  }

  @override
  Future<List<Pet>> getPetsFavorites() async {
    return await _localImpl.getPetFavorites();
  }

  @override
  Future<bool> isFavorite(Pet pet) async {
    return await _localImpl.isFavorite(pet);
  }
}

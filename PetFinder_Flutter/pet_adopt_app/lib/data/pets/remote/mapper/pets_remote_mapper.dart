import 'package:pet_adopt_app/data/pets/remote/model/pets_remote_model.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';

class PetsRemoteMapper {
  static PetsNetworkResponse fromRemote(PetsRemoteModel remoteModel) {
    return PetsNetworkResponse(
        pets: remoteModel.pets, pagination: remoteModel.pagination);
  }

  static PetsRemoteModel toRemote(PetsNetworkResponse model) {
    return PetsRemoteModel(pets: model.pets, pagination: model.pagination);
  }
}

class PetRemoteMapper {
  static PetNetworkResponse fromRemote(PetRemoteModel remoteModel) {
    return PetNetworkResponse(pet: remoteModel.pet);
  }

  static PetRemoteModel toRemote(PetNetworkResponse model) {
    return PetRemoteModel(pet: model.pet);
  }
}

class PetsTypesRemoteMapper {
  static PetsTypesNetworkResponse fromRemote(PetsTypesRemoteModel remoteModel) {
    return PetsTypesNetworkResponse(types: remoteModel.types);
  }

  static PetsTypesRemoteModel toRemote(PetsTypesNetworkResponse model) {
    return PetsTypesRemoteModel(types: model.types);
  }
}

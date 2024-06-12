// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:pet_adopt_app/data/pets/remote/model/pets_remote_model.dart';
import 'package:pet_adopt_app/data/remote/error/remote_error_mapper.dart';
import 'package:pet_adopt_app/data/remote/network_client.dart';
import 'package:pet_adopt_app/data/remote/network_constants.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';

class PetsRemoteImpl {
  final NetworkClient _networkClient;

  PetsRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Options getOptions(String token) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<PetsRemoteModel> getPets(
      String token, String type, String page) async {
    try {
      Options options = getOptions(token);

      final response = await _networkClient.dio.get(NetworkConstants.PETS_PATH,
          queryParameters: {
            'type': type,
            'page': page,
          },
          options: options);
      return PetsRemoteModel.fromMap(response.data);
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<Pet> getPet(String token, int petId) async {
    try {
      Options options = getOptions(token);
      final response = await _networkClient.dio
          .get("${NetworkConstants.PETS_PATH}/$petId", options: options);

      return PetRemoteModel.fromMap(response.data).pet;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<List<PetType>> getPetTypes(String token) async {
    try {
      Options options = getOptions(token);

      final response = await _networkClient.dio
          .get(NetworkConstants.PETS_TYPES_PATH, options: options);

      final petsTypesResponse = PetsTypesRemoteModel.fromMap(response.data);

      final typeDefaults = PetType(name: "All");
      final newResponse = [typeDefaults] + petsTypesResponse.types;
      return newResponse;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}

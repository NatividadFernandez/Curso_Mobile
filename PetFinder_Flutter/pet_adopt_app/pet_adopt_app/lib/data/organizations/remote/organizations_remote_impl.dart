import 'package:dio/dio.dart';
import 'package:pet_adopt_app/data/organizations/remote/model/organizations_remote_model.dart';
import 'package:pet_adopt_app/data/remote/error/remote_error_mapper.dart';
import 'package:pet_adopt_app/data/remote/network_client.dart';
import 'package:pet_adopt_app/data/remote/network_constants.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';

class OrganizationsRemoteImpl {
  final NetworkClient _networkClient;

  OrganizationsRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Options getOptions(String token) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<OrganizationsRemoteModel> getOrganizations(
      String token, String page) async {
    try {
      Options options = getOptions(token);
      final response =
          await _networkClient.dio.get(NetworkConstants.ORGANIZATIONS_PATH,
              queryParameters: {
                'page': page,
              },
              options: options);
      return OrganizationsRemoteModel.fromMap(response.data);
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<Organization> getOrganization(
      String token, String organizationId) async {
    try {
      Options options = getOptions(token);
      final response = await _networkClient.dio.get(
          "${NetworkConstants.ORGANIZATIONS_PATH}/$organizationId",
          options: options);
      return OrganizationRemoteModel.fromMap(response.data).organization;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}

import 'package:pet_adopt_app/data/organizations/remote/mapper/organizations_remote_mapper.dart';
import 'package:pet_adopt_app/data/organizations/remote/organizations_remote_impl.dart';
import 'package:pet_adopt_app/data/token/local/token_local_impl.dart';
import 'package:pet_adopt_app/domain/organizations_repository.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';

class OrganizationsDataImpl extends OrganizationsRepository {
  final OrganizationsRemoteImpl _remoteImpl;
  final TokenLocalImpl _tokenLocalImpl;

  OrganizationsDataImpl(
      {required OrganizationsRemoteImpl remoteImpl,
      required TokenLocalImpl tokenLocalImpl})
      : _remoteImpl = remoteImpl,
        _tokenLocalImpl = tokenLocalImpl;

  @override
  Future<OrganizationsNetworkResponse> getOrganizations(String page) async {
    final token = await _tokenLocalImpl.loadToken();
    final remoteOrganizations = await _remoteImpl.getOrganizations(token, page);
    return OrganizationsRemoteMapper.fromRemote(remoteOrganizations);
  }

  @override
  Future<Organization> getOrganization(String organizationId) async {
    final token = await _tokenLocalImpl.loadToken();
    return await _remoteImpl.getOrganization(token, organizationId);
  }
}

import 'package:pet_adopt_app/data/organizations/remote/model/organizations_remote_model.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';

class OrganizationsRemoteMapper {
  static OrganizationsNetworkResponse fromRemote(
      OrganizationsRemoteModel remoteModel) {
    return OrganizationsNetworkResponse(
        organizations: remoteModel.organizations,
        pagination: remoteModel.pagination);
  }

  static OrganizationsRemoteModel toRemote(OrganizationsNetworkResponse model) {
    return OrganizationsRemoteModel(
        organizations: model.organizations, pagination: model.pagination);
  }
}

class OrganizationRemoteMapper {
  static OrganizationNetworkResponse fromRemote(
      OrganizationRemoteModel remoteModel) {
    return OrganizationNetworkResponse(organization: remoteModel.organization);
  }

  static OrganizationRemoteModel toRemote(OrganizationNetworkResponse model) {
    return OrganizationRemoteModel(organization: model.organization);
  }
}

import 'package:pet_adopt_app/model/organization/organization.dart';

abstract class OrganizationsRepository {
  Future<OrganizationsNetworkResponse> getOrganizations(String page);
  Future<Organization> getOrganization(String organizationId);
}

import 'dart:async';

import 'package:pet_adopt_app/domain/organizations_repository.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';
import 'package:pet_adopt_app/presentation/base/base_view_model.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';

typedef OrganizationsState = ResourceState<OrganizationsNetworkResponse>;
typedef OrganizationState = ResourceState<Organization>;

class OrganizationsViewModel extends BaseViewModel {
  final OrganizationsRepository _organizationsRepository;

  final StreamController<OrganizationsState> getOrganizationsState =
      StreamController();

  final StreamController<OrganizationState> getOrganizationState =
      StreamController();

  OrganizationsViewModel(
      {required OrganizationsRepository organizationsRepository})
      : _organizationsRepository = organizationsRepository;

  fetchGetOrganizations(String page) {
    getOrganizationsState.add(ResourceState.loading());

    _organizationsRepository
        .getOrganizations(page)
        .then(
            (value) => getOrganizationsState.add(ResourceState.success(value)))
        .catchError(
            (error) => getOrganizationsState.add(ResourceState.error(error)));
  }

  fetchGetPet(String organizationId) {
    getOrganizationState.add(ResourceState.loading());

    _organizationsRepository
        .getOrganization(organizationId)
        .then((value) => getOrganizationState.add(ResourceState.success(value)))
        .catchError(
            (error) => getOrganizationState.add(ResourceState.error(error)));
  }

  @override
  void dispose() {
    getOrganizationsState.close();
    getOrganizationState.close();
  }
}

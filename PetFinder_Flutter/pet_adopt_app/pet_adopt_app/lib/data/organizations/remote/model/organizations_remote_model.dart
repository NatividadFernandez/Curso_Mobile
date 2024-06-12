import 'package:pet_adopt_app/model/common_class.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';

class OrganizationsRemoteModel {
  List<Organization> organizations;
  Pagination pagination;

  OrganizationsRemoteModel({
    required this.organizations,
    required this.pagination,
  });

  factory OrganizationsRemoteModel.fromMap(Map<String, dynamic> json) =>
      OrganizationsRemoteModel(
        organizations: List<Organization>.from(
            json["organizations"].map((x) => Organization.fromMap(x))),
        pagination: Pagination.fromMap(json["pagination"]),
      );

  Map<String, dynamic> toMap() => {
        "organizations":
            List<dynamic>.from(organizations.map((x) => x.toMap())),
        "pagination": pagination.toMap(),
      };
}

class OrganizationRemoteModel {
  Organization organization;

  OrganizationRemoteModel({required this.organization});

  factory OrganizationRemoteModel.fromMap(Map<String, dynamic> json) =>
      OrganizationRemoteModel(
        organization: Organization.fromMap(json["organization"]),
      );

  Map<String, dynamic> toMap() => {
        "organization": organization.toMap(),
      };
}

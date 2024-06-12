import 'package:pet_adopt_app/model/common_class.dart';

class OrganizationsNetworkResponse {
  List<Organization> organizations;
  Pagination pagination;

  OrganizationsNetworkResponse({
    required this.organizations,
    required this.pagination,
  });
}

class OrganizationNetworkResponse {
  Organization organization;

  OrganizationNetworkResponse({required this.organization});
}

class Organization {
  String id;
  String name;
  String? email;
  String? phone;
  Address? address;
  Hours? hours;
  String url;
  String? missionStatement;
  List<Photo>? photos;

  Organization({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.hours,
    required this.url,
    required this.missionStatement,
    required this.photos,
  });

  List<Hour> get hoursList {
    return [
      Hour(id: 1, title: "monday", label: hours?.monday ?? "--"),
      Hour(id: 2, title: "tuesday", label: hours?.tuesday ?? "--"),
      Hour(id: 3, title: "wednesday", label: hours?.wednesday ?? "--"),
      Hour(id: 4, title: "thursday", label: hours?.thursday ?? "--"),
      Hour(id: 5, title: "friday", label: hours?.friday ?? "--"),
      Hour(id: 6, title: "saturday", label: hours?.saturday ?? "--"),
      Hour(id: 7, title: "sunday", label: hours?.sunday ?? "--"),
    ];
  }

  factory Organization.fromMap(Map<String, dynamic> json) => Organization(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address:
            json["address"] != null ? Address.fromMap(json["address"]) : null,
        hours: json["hours"] != null ? Hours.fromMap(json["hours"]) : null,
        url: json["url"],
        missionStatement: json["mission_statement"],
        photos: (json["photos"] as List<dynamic>?)
            ?.map((x) => Photo.fromMap(x))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address?.toMap(),
        "hours": hours?.toMap(),
        "url": url,
        "mission_statement": missionStatement,
        "photos": photos?.map((x) => x.toMap()),
      };
}

class Hours {
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;

  Hours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory Hours.fromMap(Map<String, dynamic> json) => Hours(
        monday: json["monday"],
        tuesday: json["tuesday"],
        wednesday: json["wednesday"],
        thursday: json["thursday"],
        friday: json["friday"],
        saturday: json["saturday"],
        sunday: json["sunday"],
      );

  Map<String, dynamic> toMap() => {
        "monday": monday,
        "tuesday": tuesday,
        "wednesday": wednesday,
        "thursday": thursday,
        "friday": friday,
        "saturday": saturday,
        "sunday": sunday,
      };
}

class Hour {
  final int id;
  final String title;
  final String label;

  Hour({required this.id, required this.title, required this.label});
}

class Contact {
  String? email;
  String? phone;
  Address? address;

  Contact({
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        email: json["email"],
        phone: json["phone"],
        address: Address.fromMap(json["address"]),
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "phone": phone,
        "address": address?.toMap(),
      };
}

class Address {
  String? city;

  Address({
    required this.city,
  });

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        city: json["city"],
      );

  Map<String, dynamic> toMap() => {
        "city": city,
      };
}

class Photo {
  String? full;

  Photo({
    required this.full,
  });

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
        full: json["full"],
      );

  Map<String, dynamic> toMap() => {
        "full": full,
      };
}

class Pagination {
  int countPerPage;
  int totalCount;
  int currentPage;
  int totalPages;

  Pagination({
    required this.countPerPage,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
        countPerPage: json["count_per_page"],
        totalCount: json["total_count"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toMap() => {
        "count_per_page": countPerPage,
        "total_count": totalCount,
        "current_page": currentPage,
        "total_pages": totalPages,
      };
}

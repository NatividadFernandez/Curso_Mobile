// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class NetworkConstants {
  static const String _CLIENT_ID =
      "RYHZfNQzfknAAaIzGmsh1K8z2cHX485pLWTQMDwvuyyxPDLHT9";
  static const String _CLIENT_SECRET =
      "XkvPGumoamjFgHAxrfvYHaTr5GEaUYrLHqxpshq8";
  static const String _GRANT_TYPE = "client_credentials";
  static const String AUTH_NETWORK_URL =
      "https://api.petfinder.com/v2/oauth2/token";

  static const String KEY_TOKEN = "save_token";

  static const String BASE_URL = "https://api.petfinder.com/v2";

  static const String PETS_PATH = "$BASE_URL/animals";
  static const String PETS_TYPES_PATH = "$BASE_URL/types";
  static const String ORGANIZATIONS_PATH = "$BASE_URL/organizations";

  static Map<String, String> get BODY_PARAMS {
    return {
      "client_id": _CLIENT_ID,
      "client_secret": _CLIENT_SECRET,
      "grant_type": _GRANT_TYPE,
    };
  }

  static const String FAVORITES_TABLE = "favorites";
}

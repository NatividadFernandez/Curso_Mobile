class TokenRemoteModel {
  String tokenType;
  int expiresIn;
  String accessToken;

  TokenRemoteModel({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
  });

  factory TokenRemoteModel.fromMap(Map<String, dynamic> json) =>
      TokenRemoteModel(
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        accessToken: json['access_token'],
      );

  Map<String, dynamic> toMap() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
      };
}

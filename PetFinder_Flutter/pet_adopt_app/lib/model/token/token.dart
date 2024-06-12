class Token {
  String tokenType;
  int expiresIn;
  String accessToken;

  Token({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
  });
}

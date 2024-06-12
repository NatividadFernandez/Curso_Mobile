import 'package:pet_adopt_app/data/token/remote/model/token_remote_model.dart';
import 'package:pet_adopt_app/model/token/token.dart';

class TokenRemoteMapper {
  static Token fromRemote(TokenRemoteModel remoteModel) {
    return Token(
      tokenType: remoteModel.tokenType,
      expiresIn: remoteModel.expiresIn,
      accessToken: remoteModel.accessToken,
    );
  }

  // Unused
  static TokenRemoteModel toRemote(Token model) {
    return TokenRemoteModel(
      tokenType: model.tokenType,
      expiresIn: model.expiresIn,
      accessToken: model.accessToken,
    );
  }
}

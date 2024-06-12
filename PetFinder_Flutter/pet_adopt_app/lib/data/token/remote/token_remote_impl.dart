import 'package:pet_adopt_app/data/remote/error/remote_error_mapper.dart';
import 'package:pet_adopt_app/data/remote/network_client.dart';
import 'package:pet_adopt_app/data/remote/network_constants.dart';
import 'package:pet_adopt_app/data/token/remote/model/token_remote_model.dart';

class TokenRemoteImpl {
  final NetworkClient _networkClient;

  TokenRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<TokenRemoteModel> createToken() async {
    try {
      final response = await _networkClient.dio.post(
        NetworkConstants.AUTH_NETWORK_URL,
        data: NetworkConstants.BODY_PARAMS,
      );
      return TokenRemoteModel.fromMap(response.data);
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}

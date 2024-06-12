import 'package:pet_adopt_app/data/token/local/token_local_impl.dart';
import 'package:pet_adopt_app/data/token/remote/mapper/token_remote_mapper.dart';
import 'package:pet_adopt_app/data/token/remote/token_remote_impl.dart';
import 'package:pet_adopt_app/domain/token_repositoy.dart';

class TokenDataImpl extends TokenRepository {
  final TokenRemoteImpl _remoteImpl;
  final TokenLocalImpl _localImpl;

  TokenDataImpl(
      {required TokenRemoteImpl remoteImpl, required TokenLocalImpl localImpl})
      : _remoteImpl = remoteImpl,
        _localImpl = localImpl;

  @override
  Future createToken() async {
    final remoteToken = await _remoteImpl.createToken();
    await _localImpl
        .saveToken(TokenRemoteMapper.fromRemote(remoteToken).accessToken);
  }
}

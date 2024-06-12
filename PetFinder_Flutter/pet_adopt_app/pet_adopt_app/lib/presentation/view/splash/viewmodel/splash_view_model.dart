import 'dart:async';

import 'package:pet_adopt_app/domain/token_repositoy.dart';
import 'package:pet_adopt_app/model/token/token.dart';
import 'package:pet_adopt_app/presentation/base/base_view_model.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';

typedef CreateTokenState = ResourceState<Token>;

class SplashViewModel extends BaseViewModel {
  final TokenRepository _tokenRepository;

  final StreamController<CreateTokenState> getCreateTokenState =
      StreamController();

  SplashViewModel({required TokenRepository tokenRepository})
      : _tokenRepository = tokenRepository;

  fetchCreateToken() {
    getCreateTokenState.add(ResourceState.loading());

    _tokenRepository
        .createToken()
        .then((value) => getCreateTokenState.add(ResourceState.success(value)))
        .catchError(
            (error) => getCreateTokenState.add(ResourceState.error(error)));
  }

  @override
  void dispose() {
    getCreateTokenState.close();
  }
}

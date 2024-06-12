import 'package:pet_adopt_app/data/remote/network_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenLocalImpl {
  final SharedPreferences _preferences;

  TokenLocalImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  loadToken() {
    return _preferences.getString(NetworkConstants.KEY_TOKEN);
  }

  saveToken(String token) {
    _preferences.setString(NetworkConstants.KEY_TOKEN, token);
  }
}

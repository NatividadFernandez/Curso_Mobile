import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_adopt_app/data/organizations/organizations_data_impl.dart';
import 'package:pet_adopt_app/data/organizations/remote/organizations_remote_impl.dart';
import 'package:pet_adopt_app/data/pets/local/pets_local_impl.dart';
import 'package:pet_adopt_app/data/pets/pets_data_impl.dart';
import 'package:pet_adopt_app/data/pets/remote/pets_remote_impl.dart';
import 'package:pet_adopt_app/data/remote/network_client.dart';
import 'package:pet_adopt_app/data/token/local/token_local_impl.dart';
import 'package:pet_adopt_app/data/token/remote/token_remote_impl.dart';
import 'package:pet_adopt_app/data/token/token_data_impl.dart';
import 'package:pet_adopt_app/domain/organizations_repository.dart';
import 'package:pet_adopt_app/domain/pets_repository.dart';
import 'package:pet_adopt_app/domain/token_repositoy.dart';
import 'package:pet_adopt_app/presentation/view/organization/viewmodel/organizations_view_model.dart';
import 'package:pet_adopt_app/presentation/view/pet/viewmodel/pets_view_model.dart';
import 'package:pet_adopt_app/presentation/view/provider/pet_favorite_provider.dart';
import 'package:pet_adopt_app/presentation/view/splash/viewmodel/splash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final inject = GetIt.instance;

class AppModules {
  setup() async {
    await _setupMainModule();
    await _setupPetModule();
  }

  _setupMainModule() async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    inject.registerSingleton<SharedPreferences>(prefs);

    inject.registerSingleton(NetworkClient());

    inject.registerSingleton(PetFavoriteProvider());
  }

  _setupPetModule() {
    //Token
    inject.registerFactory(() => TokenRemoteImpl(networkClient: inject.get()));
    inject.registerFactory(() => TokenLocalImpl(preferences: inject.get()));
    inject.registerFactory<TokenRepository>(
        () => TokenDataImpl(remoteImpl: inject.get(), localImpl: inject.get()));
    inject
        .registerFactory(() => SplashViewModel(tokenRepository: inject.get()));

    // Pets
    inject.registerFactory(() => PetsRemoteImpl(networkClient: inject.get()));
    inject.registerFactory(() => PetsLocalImpl());
    inject.registerFactory<PetsRepository>(() => PetsDataImpl(
        remoteImpl: inject.get(),
        localImpl: inject.get(),
        tokenLocalImpl: inject.get()));

    inject.registerFactory(() => PetsViewModel(petsRepository: inject.get()));

    // Organizations
    inject.registerFactory(
        () => OrganizationsRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<OrganizationsRepository>(() => OrganizationsDataImpl(
        remoteImpl: inject.get(), tokenLocalImpl: inject.get()));

    inject.registerFactory(
        () => OrganizationsViewModel(organizationsRepository: inject.get()));
  }
}

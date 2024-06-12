import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adopt_app/di/app_modules.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';
import 'package:pet_adopt_app/presentation/view/pet/viewmodel/pets_view_model.dart';
import 'package:pet_adopt_app/presentation/view/provider/pet_favorite_provider.dart';
import 'package:pet_adopt_app/presentation/widget/error/error_view.dart';
import 'package:pet_adopt_app/presentation/widget/label_with_icon.dart';
import 'package:pet_adopt_app/presentation/widget/loading/loading_view.dart';

class PetDetailPage extends StatefulWidget {
  const PetDetailPage({super.key, required this.petId, required this.route});

  final String petId;
  final String route;

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final PetsViewModel _viewModel = inject<PetsViewModel>();
  final PetFavoriteProvider _favoriteProvider = inject<PetFavoriteProvider>();
  Pet? _pet;

  @override
  void initState() {
    super.initState();

    _favoriteProvider.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _viewModel.getPetState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _pet = state.data!;
            _viewModel.isPetFavorite(_pet!);
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchGetPet(int.parse(widget.petId));
          });
          break;
      }
    });

    _viewModel.fetchGetPet(int.parse(widget.petId));

    _viewModel.isPetFavoriteState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          break;
        case Status.SUCCESS:
          setState(() {
            _favoriteProvider.isPetFavorite(state.data!);
          });
          break;
        case Status.ERROR:
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.isPetFavorite(_pet!);
          });
          break;
      }
    });

    _viewModel.addPetsFavoritesState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          break;
        case Status.SUCCESS:
          setState(() {
            showSnackBar(Colors.green, "Added to favorites", Icons.check);
            _favoriteProvider.addPetFavorite(_pet!);
            _viewModel.fetchGetPetsFavorites();
          });
          break;
        case Status.ERROR:
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.addPetFavorites(_pet!);
          });
          break;
      }
    });

    _viewModel.deletePetFavoritesState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          break;
        case Status.SUCCESS:
          setState(() {
            showSnackBar(Colors.red, "Removed from favorites", Icons.delete);
            _favoriteProvider.deletePetFavorite(_pet!);
            _viewModel.fetchGetPetsFavorites();
          });
          break;
        case Status.ERROR:
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.deletePetFavorites(_pet!);
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pet?.name ?? "Loading...",
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(156, 115, 248, 1.0),
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _favoriteProvider.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: const Color.fromRGBO(156, 115, 248, 1.0),
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _favoriteProvider.isPetFavorite(!_favoriteProvider.isFavorite);
                toggleFavoritePet(_pet!);
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: contentImage(200, 200, _pet),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _pet?.name ?? "Loading...",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(56, 2, 100, 1.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  _pet?.breeds?.primary ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            LabelWithIcon(
                              text: _pet?.contact?.address?.city ?? "No data",
                              icon: Icons.location_on,
                              iconSize: 25,
                              result: false,
                              iconColor:
                                  const Color.fromRGBO(156, 115, 248, 1.0),
                              textSize: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        characteristicScrollView(_pet),
                        const SizedBox(height: 10),
                        contentDescription(_pet),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: contentHorizontal(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => {
          //NavigationRoutes.PET_ORGANIZATION_DETAIL_ROUTE
          context.go(widget.route, extra: _pet!.organizationId)
        },
        backgroundColor: const Color.fromRGBO(156, 115, 248, 1.0),
        child: const Icon(
          Icons.location_city_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget contentImage(double width, double height, Pet? pet) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10.0),
              bottom: Radius.circular(10.0),
            ),
            child: pet?.photos != null && pet!.photos!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: pet.photos!.first.full ?? "",
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/pet_placeholder.jpg',
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget characteristicScrollView(Pet? pet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: (pet?.characteristics ?? []).map((characteristic) {
        return SizedBox(
          width: 120,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(156, 115, 248, 1.0),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  capitalize(characteristic.title),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                Text(
                  characteristic.label,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget contentDescription(Pet? pet) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(56, 2, 100, 1.0),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 160,
            child: SingleChildScrollView(
              child: Text(_pet?.description ?? "There is no information"),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentHorizontal() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelWithIcon(
                  text: _pet?.contact?.phone ?? "No data",
                  icon: Icons.phone,
                  iconSize: 25,
                  result: false,
                  iconColor: const Color.fromRGBO(156, 115, 248, 1.0),
                  textSize: 16,
                ),
                const SizedBox(height: 5),
                LabelWithIcon(
                  text: _pet?.contact?.email ?? "No data",
                  icon: Icons.email,
                  iconSize: 25,
                  result: false,
                  iconColor: const Color.fromRGBO(156, 115, 248, 1.0),
                  textSize: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future toggleFavoritePet(Pet pet) async {
    if (_favoriteProvider.isFavorite) {
      await _viewModel.addPetFavorites(pet);
    } else {
      await _viewModel.deletePetFavorites(pet);
    }
  }

  showSnackBar(Color color, String text, IconData icon) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}


 /*Widget characteristicScrollView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._pet?.characteristics
                .where((info) => info.title.toLowerCase() != "unknown")
                .map((info) => Container(
                      width: 90,
                      height: 90,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.purpleLight,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            info.label.capitalize(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(info.title.capitalize()),
                        ],
                      ),
                    )) ??
            [],
      ],
    );
  }
*/
 

 /*
 FilledButton(
          onPressed: () {
            context.go(NavigationRoutes.PET_ORGANIZATION_DETAIL_ROUTE,
                extra: _pet!.organizationId);
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_city_outlined,
                size: 30,
                color: Color.fromRGBO(156, 115, 248, 1.0),
              ),
            ],
          ),
        ),
 
 ElevatedButton(
          onPressed: () {
            // Acciones a realizar cuando se presiona el botón
            print('Button pressed!');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
                156, 115, 248, 1.0), // Color de fondo del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
            ),
            minimumSize: const Size(20, 20), // Ancho y alto del botón
          ),
          child: const Icon(
            Icons.location_city_outlined,
            size: 30,
            color: Colors.white,
          ),
          /*IconButton(
          onPressed: () {
            context.go("/pet/pet-detail/organization-detail",
                extra: _pet!.organizationId);
          },
          icon: const Icon(
            Icons.location_city_outlined,
            size: 30,
            color: Color.fromRGBO(156, 115, 248, 1.0),
          ),
        ),*/
        ),*/


/*Widget makeFavoriteButton(Pet pet) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await toggleFavoritePet(pet);
          //popHandler?.call();
          //showToast = true;
        } catch (error) {
          // Maneja el error según tus necesidades, como imprimirlo o mostrar un mensaje al usuario.
          print("Error al realizar la acción de favorito: $error");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Icon(
        _viewModel.isFavorite(pet) ? Icons.favorite : Icons.favorite_border,
        size: 30,
        color: Colors.white,
      ),
    );
      }*/
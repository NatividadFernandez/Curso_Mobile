import 'package:flutter/material.dart';
import 'package:pet_adopt_app/di/app_modules.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';
import 'package:pet_adopt_app/presentation/navigation/navigation_routes.dart';
import 'package:pet_adopt_app/presentation/view/pet/viewmodel/pets_view_model.dart';
import 'package:pet_adopt_app/presentation/view/provider/pet_favorite_provider.dart';
import 'package:pet_adopt_app/presentation/widget/error/error_view.dart';
import 'package:pet_adopt_app/presentation/widget/pet_list_row.dart';

class PetFavoritePage extends StatefulWidget {
  const PetFavoritePage({super.key});

  @override
  State<PetFavoritePage> createState() => _PetFavoritePageState();
}

class _PetFavoritePageState extends State<PetFavoritePage> {
  final PetsViewModel _viewModel = inject<PetsViewModel>();
  final PetFavoriteProvider _petFavoriteProvider =
      inject<PetFavoriteProvider>();

  @override
  void initState() {
    super.initState();

    _petFavoriteProvider.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _viewModel.getPetsFavoritesState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          break;
        case Status.SUCCESS:
          setState(() {
            _petFavoriteProvider.newFavoriteList(state.data!);
          });
          break;
        case Status.ERROR:
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchGetPetsFavorites();
          });
          break;
      }
    });
    _viewModel.fetchGetPetsFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(156, 115, 248, 1.0),
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.89,
            ),
            itemCount: _petFavoriteProvider.petFavoriteList.length,
            itemBuilder: (context, index) {
              final item = _petFavoriteProvider.petFavoriteList[index];
              return PetListRow(
                pet: item,
                route: NavigationRoutes.PET_FAVORITE_DETAIL_ROUTE,
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pet_adopt_app/di/app_modules.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';
import 'package:pet_adopt_app/presentation/navigation/navigation_routes.dart';
import 'package:pet_adopt_app/presentation/view/pet/viewmodel/pets_view_model.dart';
import 'package:pet_adopt_app/presentation/widget/error/error_view.dart';
import 'package:pet_adopt_app/presentation/widget/loading/loading_view.dart';
import 'package:pet_adopt_app/presentation/widget/pet_list_row.dart';
import 'package:pet_adopt_app/presentation/widget/search_bar.dart';

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  final PetsViewModel _viewModel = inject<PetsViewModel>();
  final ScrollController _scrollController = ScrollController();
  final List<Pet> _pets = List.empty(growable: true);
  List<PetType> _petsTypes = List.empty(growable: true);
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  bool _hasMoreItems = true;
  int _nextPage = 1;

  String petType = "All";

  String getDefaultPetType(String petType) {
    return petType == "All" ? "" : petType;
  }

  List<Pet> getFilteredPets() {
    if (_searchTerm.isEmpty) {
      return _pets;
    } else {
      return _pets
          .where((pet) =>
              pet.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
              pet.age.toLowerCase().contains(_searchTerm.toLowerCase()))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();

    _viewModel.getPetsTypesState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _petsTypes = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchGetPetsTypes();
          });
          break;
      }
    });

    _viewModel.fetchGetPetsTypes();

    _viewModel.getPetsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _addPets(state.data!);
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchGetPets(
                getDefaultPetType(petType), _nextPage.toString());
          });
          break;
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreItems) {
        _viewModel.fetchGetPets(
            getDefaultPetType(petType), _nextPage.toString());
      }
    });

    _viewModel.fetchGetPets(getDefaultPetType(petType), _nextPage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pets"),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(156, 115, 248, 1.0),
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value;
                  });
                },
                labelText: 'Search pets by name or age',
                controller: _searchController,
              ),
              const Text(
                "Types",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(66, 66, 66, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildCategoryChips(),
              const Text(
                "Pets",
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromRGBO(66, 66, 66, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: _getContentView(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1050),
          curve: Curves.decelerate,
        ),
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _getContentView() {
    final filteredPets = getFilteredPets();

    return RefreshIndicator(
      onRefresh: () async {
        _nextPage = 1;
        _viewModel.fetchGetPets(
            getDefaultPetType(petType), _nextPage.toString());
      },
      child: Scrollbar(
        controller: _scrollController,
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.89,
          ),
          itemCount: filteredPets.length,
          itemBuilder: (context, index) {
            final item = filteredPets[index];
            return PetListRow(
              pet: item,
              route: NavigationRoutes.PET_DETAIL_ROUTE,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: _petsTypes.map((type) {
          bool isSelected = petType == type.name;
          return Padding(
            padding: const EdgeInsets.only(left: 5),
            child: InkWell(
                onTap: () {
                  setState(() {
                    petType = isSelected ? '' : type.name;
                    _nextPage = 1;
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 1050),
                      curve: Curves.decelerate,
                    );
                    _searchController.clear();
                  });
                  _viewModel.fetchGetPets(
                      getDefaultPetType(petType), _nextPage.toString());
                },
                child: Chip(
                  label: Text(
                    type.name,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color.fromRGBO(156, 115, 248, 1.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: isSelected
                      ? const Color.fromRGBO(156, 115, 248, 1.0)
                      : Colors.grey[200],
                  elevation: 2.0,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(
                      color: Color.fromRGBO(156, 115, 248, 1.0),
                      width: 2.0,
                    ),
                  ),
                )),
          );
        }).toList(),
      ),
    );
  }

  _addPets(PetsNetworkResponse response) {
    if (_nextPage == 1) {
      _pets.clear();
    }
    _pets.addAll(response.pets);
    LoadingView.hide();
    _hasMoreItems = response.pagination.totalCount > _pets.length;
    _nextPage += 1;

    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:pet_adopt_app/di/app_modules.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';
import 'package:pet_adopt_app/presentation/view/organization/viewmodel/organizations_view_model.dart';
import 'package:pet_adopt_app/presentation/widget/error/error_view.dart';
import 'package:pet_adopt_app/presentation/widget/loading/loading_view.dart';
import 'package:pet_adopt_app/presentation/widget/organization_list_row.dart';
import 'package:pet_adopt_app/presentation/widget/search_bar.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final OrganizationsViewModel _viewModel = inject<OrganizationsViewModel>();
  final ScrollController _scrollController = ScrollController();
  final List<Organization> _organizations = List.empty(growable: true);
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  bool _hasMoreItems = true;
  int _nextPage = 1;

  List<Organization> getFilteredOrganizations() {
    if (_searchTerm.isEmpty) {
      return _organizations;
    } else {
      return _organizations
          .where((pet) =>
              pet.name.toLowerCase().contains(_searchTerm.toLowerCase()))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();

    _viewModel.getOrganizationsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _addOrganizations(state.data!);
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchGetOrganizations(_nextPage.toString());
          });
          break;
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreItems) {
        _viewModel.fetchGetOrganizations(_nextPage.toString());
      }
    });

    _viewModel.fetchGetOrganizations(_nextPage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organizations"),
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
                labelText: 'Search organizations by name',
                controller: _searchController,
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
    final filteredOrganizations = getFilteredOrganizations();

    return RefreshIndicator(
      onRefresh: () async {
        _nextPage = 1;
        _viewModel.fetchGetOrganizations(_nextPage.toString());
      },
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: filteredOrganizations.length,
          itemBuilder: (context, index) {
            final item = filteredOrganizations[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OrganizationListRow(organization: item),
            );
          },
        ),
      ),
    );
  }

  _addOrganizations(OrganizationsNetworkResponse response) {
    if (_nextPage == 1) {
      _organizations.clear();
    }
    _organizations.addAll(response.organizations);
    LoadingView.hide();
    _hasMoreItems = response.pagination.totalCount > _organizations.length;
    _nextPage += 1;

    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

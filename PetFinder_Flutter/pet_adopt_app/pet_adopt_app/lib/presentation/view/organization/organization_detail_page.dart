import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_adopt_app/di/app_modules.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';
import 'package:pet_adopt_app/presentation/view/organization/viewmodel/organizations_view_model.dart';
import 'package:pet_adopt_app/presentation/widget/error/error_view.dart';
import 'package:pet_adopt_app/presentation/widget/label_with_icon.dart';
import 'package:pet_adopt_app/presentation/widget/loading/loading_view.dart';

class OrganizationDetailPage extends StatefulWidget {
  const OrganizationDetailPage({super.key, required this.organizationId});

  final String organizationId;
  @override
  State<OrganizationDetailPage> createState() => _OrganizationDetailPageState();
}

class _OrganizationDetailPageState extends State<OrganizationDetailPage> {
  final OrganizationsViewModel _viewModel = inject<OrganizationsViewModel>();

  Organization? _organization;

  @override
  void initState() {
    super.initState();

    _viewModel.getOrganizationState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _organization = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchGetPet(widget.organizationId);
          });
          break;
      }
    });

    _viewModel.fetchGetPet(widget.organizationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _organization?.name ?? "Loading...",
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(156, 115, 248, 1.0),
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.3),
        centerTitle: true,
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
                      child: contentImage(200, 200),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _organization?.name ?? "Loading...",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(56, 2, 100, 1.0),
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
                              text: _organization?.address?.city ?? "No data",
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
                        hoursScrollView(),
                        const SizedBox(height: 10),
                        contentDescription(),
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
    );
  }

  Widget contentImage(double width, double height) {
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
            child: _organization?.photos != null &&
                    _organization!.photos!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: _organization?.photos!.first.full ?? "",
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

  Widget hoursScrollView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: (_organization?.hoursList ?? []).map((hours) {
          return SizedBox(
            width: 150,
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
                    capitalize(hours.title),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    hours.label,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget contentDescription() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Task",
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
              child: Text(
                  _organization?.missionStatement ?? "There is no information"),
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
                  text: _organization?.phone ?? "No data",
                  icon: Icons.phone,
                  iconSize: 25,
                  result: false,
                  iconColor: const Color.fromRGBO(156, 115, 248, 1.0),
                  textSize: 16,
                ),
                const SizedBox(height: 5),
                LabelWithIcon(
                  text: _organization?.email ?? "No data",
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

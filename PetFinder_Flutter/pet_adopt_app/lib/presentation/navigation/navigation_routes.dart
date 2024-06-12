// ignore_for_file: constant_identifier_names

import 'package:go_router/go_router.dart';
import 'package:pet_adopt_app/presentation/view/home_page.dart';
import 'package:pet_adopt_app/presentation/view/organization/organization_detail_page.dart';
import 'package:pet_adopt_app/presentation/view/organization/organizations_page.dart';
import 'package:pet_adopt_app/presentation/view/pet/pet_detail_page.dart';
import 'package:pet_adopt_app/presentation/view/pet/pet_favorite_page.dart';
import 'package:pet_adopt_app/presentation/view/pet/pets_page.dart';
import 'package:pet_adopt_app/presentation/view/splash/splash_page.dart';

class NavigationRoutes {
  static const INITIAL_ROUTE = "/";

  static const PET_ROUTE = "/pet";
  static const PET_DETAIL_ROUTE = "$PET_ROUTE/$_PET_DETAIL_PATH";
  static const PET_ORGANIZATION_DETAIL_ROUTE =
      "$PET_DETAIL_ROUTE/$_ORGANIZATION_DETAIL_PATH";

  static const ORGANIZATION_ROUTE = "/organization";
  static const ORGANIZATION_DETAIL_ROUTE =
      "$ORGANIZATION_ROUTE/$_ORGANIZATION_DETAIL_PATH";

  static const PET_FAVORITE_ROUTE = "/favorite";
  static const PET_FAVORITE_DETAIL_ROUTE =
      "$PET_FAVORITE_ROUTE/$_PET_DETAIL_PATH";
  static const PET_FAVORITE_ORGANIZATION_DETAIL_ROUTE =
      "$PET_FAVORITE_DETAIL_ROUTE/$_ORGANIZATION_DETAIL_PATH";

  // Paths
  static const _PET_DETAIL_PATH = "pet-detail";
  static const _ORGANIZATION_DETAIL_PATH = "organization-detail";
}

final GoRouter router = GoRouter(
  initialLocation: NavigationRoutes.INITIAL_ROUTE,
  routes: [
    GoRoute(
      path: NavigationRoutes.INITIAL_ROUTE,
      builder: (context, state) => const SplashPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomePage(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.PET_ROUTE,
            builder: (context, state) => const PetPage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._PET_DETAIL_PATH,
                builder: (context, state) {
                  final petId = state.extra as String;
                  return PetDetailPage(
                    petId: petId,
                    route: NavigationRoutes.PET_ORGANIZATION_DETAIL_ROUTE,
                  );
                },
                routes: [
                  GoRoute(
                    path: NavigationRoutes._ORGANIZATION_DETAIL_PATH,
                    builder: (context, state) {
                      final orgId = state.extra as String;
                      return OrganizationDetailPage(organizationId: orgId);
                    },
                  ),
                ],
              ),
            ],
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.ORGANIZATION_ROUTE,
            builder: (context, state) => const OrganizationPage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._ORGANIZATION_DETAIL_PATH,
                builder: (context, state) => OrganizationDetailPage(
                    organizationId: state.extra as String),
              )
            ],
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.PET_FAVORITE_ROUTE,
            builder: (context, state) => const PetFavoritePage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._PET_DETAIL_PATH,
                builder: (context, state) => PetDetailPage(
                    petId: state.extra as String,
                    route: NavigationRoutes
                        .PET_FAVORITE_ORGANIZATION_DETAIL_ROUTE),
                routes: [
                  GoRoute(
                    path: NavigationRoutes._ORGANIZATION_DETAIL_PATH,
                    builder: (context, state) {
                      final orgId = state.extra as String;
                      return OrganizationDetailPage(organizationId: orgId);
                    },
                  ),
                ],
              )
            ],
          )
        ]),
      ],
    )
  ],
);

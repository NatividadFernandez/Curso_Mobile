import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_adopt_app/di/app_modules.dart';
import 'package:pet_adopt_app/presentation/model/resource_state.dart';
import 'package:pet_adopt_app/presentation/navigation/navigation_routes.dart';
import 'package:pet_adopt_app/presentation/view/splash/viewmodel/splash_view_model.dart';
import 'package:pet_adopt_app/presentation/widget/error/error_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashViewModel _splashViewModel = inject<SplashViewModel>();

  @override
  void initState() {
    super.initState();

    _splashViewModel.getCreateTokenState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          break;
        case Status.SUCCESS:
          setState(() {
            navigateToNextPage();
          });
          break;
        case Status.ERROR:
          ErrorView.show(context, state.exception!.toString(), () {
            _splashViewModel.fetchCreateToken();
          });
          break;
      }
    });

    _splashViewModel.fetchCreateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/lottie/animation_pet.json",
              repeat: true,
              animate: true,
              width: 350,
            ),
            const SizedBox(height: 16),
            Text(
              'Pet Adopt',
              style: GoogleFonts.montserrat(
                color: const Color.fromRGBO(156, 115, 248, 1.0),
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      context.go(NavigationRoutes.PET_ROUTE);
    }
  }

  @override
  void dispose() {
    _splashViewModel.dispose();
    super.dispose();
  }
}

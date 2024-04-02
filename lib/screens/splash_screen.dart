import 'package:flutter/material.dart';
import 'package:renta_movil_app/screens/dashboard_screen.dart';
import 'package:splash_view/source/presentation/pages/pages.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
      backgroundColor: Colors.black,
      loadingIndicator: Image.asset('images/load.gif'),
      done: Done(const DashboardScreen(),
      animationDuration: const Duration(milliseconds: 3000)
      ),
    );
  }
}
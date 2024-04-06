import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:renta_movil_app/screens/categoria_screen.dart';
import 'package:renta_movil_app/screens/dashboard_screen.dart';
import 'package:renta_movil_app/screens/mobiliario_categoria_screen.dart';
import 'package:renta_movil_app/screens/mobiliario_screen.dart';
import 'package:renta_movil_app/screens/rent_form.dart';
import 'package:renta_movil_app/screens/renta_detalle_screen.dart';
import 'package:renta_movil_app/screens/splash_screen.dart';
import 'package:renta_movil_app/screens/status_screen.dart';
import 'package:renta_movil_app/services/theme_services.dart';
import 'package:renta_movil_app/settings/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('es_MX', null);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App_Mobiliario',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const SplashScreen(),
      routes: {
        "/dash": (BuildContext context) => const DashboardScreen(),
        "/rentForm": (BuildContext context) => const RentForm(),
        "/status": (BuildContext context) => const StatusScreen(),
        "/categoria": (BuildContext context) => const CategoriaScreen(),
        "/mobiliario": (BuildContext context) => const MobiliarioScreen(),
        "/mobiliarioCategoria": (BuildContext context) => const MobCatScreen(),
        "/rentaDetalle": (BuildContext context) => const RenDetScreen(),
      },
    );
  }
}

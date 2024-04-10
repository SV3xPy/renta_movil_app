import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renta_movil_app/services/notification_service.dart';
import 'package:renta_movil_app/services/theme_services.dart';

Drawer MenuLateral(BuildContext context) {
  return Drawer(
    child: Stack(
      children: [
        ListView(
          children: [
            DrawerHeader(
              child: Container(),
            ),
            ExpansionTile(
              leading: Icon(Icons.book),
              title: const Text('Rentas'),
              subtitle: const Text('Gestion de rentas.'),
              trailing: const Icon(Icons.chevron_right),
              children: [
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Administrar rentas'),
                  onTap: () => Navigator.pushNamed(context, "/dash"),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Administrar tipos de Status'),
                  onTap: () => Navigator.pushNamed(context, "/status"),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.chair),
              title: const Text('Mobiliario'),
              subtitle: const Text('Gestion de mobiliario.'),
              trailing: const Icon(Icons.chevron_right),
              children: [
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Administrar mobiliario'),
                  onTap: () => Navigator.pushNamed(context, "/mobiliario"),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Administrar categorias'),
                  onTap: () => Navigator.pushNamed(context, "/categoria"),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              ThemeService().switchTheme();
            },
            child: Icon(
              Get.isDarkMode
                  ? Icons.brightness_high_rounded
                  : Icons.nightlight_round,
              size: 30,
            ),
          ),
        )
      ],
    ),
  );
}

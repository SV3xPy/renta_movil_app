import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';

class MobiliarioCategoriaTitle extends StatefulWidget {
  final CategoriaModel categoria;
  const MobiliarioCategoriaTitle({super.key, required this.categoria});

  @override
  State<MobiliarioCategoriaTitle> createState() =>
      __MobiliarioCategoriaTitleState();
}

class __MobiliarioCategoriaTitleState
    extends State<MobiliarioCategoriaTitle> {
  late Color _randomColor;

  @override
  void initState() {
    super.initState();
    _randomColor = _generateRandomColor();
  }

  Color _generateRandomColor() {
    // Genera un color aleatorio
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _randomColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.categoria.nombreCategoria!,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ))
          ],),
      ),
    );
  }
}

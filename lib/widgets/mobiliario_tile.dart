import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';

class MobiliarioTile extends StatefulWidget {
  final MobiliarioModel mobiliario;

  const MobiliarioTile({super.key, required this.mobiliario});

  @override
  State<MobiliarioTile> createState() => _MobiliarioTileState();
}

class _MobiliarioTileState extends State<MobiliarioTile> {
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
                    widget.mobiliario.nombreMobiliario!,
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
                  Text(
                    widget.mobiliario.descripcionMobiliario!,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.numbers,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Total: ${widget.mobiliario.cantidadTotalMobiliario}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[100],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Disponible: ${widget.mobiliario.cantidadDisponibleMobiliario}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[100],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                "Precio: ${widget.mobiliario.precioRentaMobiliario}",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

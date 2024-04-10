import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';

class RentaDetalleTitle extends StatefulWidget {
  final RentaDetalleNombreModel detalles;
  const RentaDetalleTitle({super.key, required this.detalles});

  @override
  State<RentaDetalleTitle> createState() => _RentaDetalleTitleState();
}

class _RentaDetalleTitleState extends State<RentaDetalleTitle> {
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
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.detalles.nombreMobiliario!,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.currency_exchange,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Precio Unitario: ${widget.detalles.precioUnitarioDetalle}",
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.production_quantity_limits_outlined,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Cantidad: ${widget.detalles.cantidadDetalle}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

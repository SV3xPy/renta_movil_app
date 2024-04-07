import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:renta_movil_app/database/mobiliario_database.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:renta_movil_app/screens/app_value_notifier.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/input_field.dart';
import 'package:flutter/services.dart';
import 'package:renta_movil_app/widgets/renta_detalle_title.dart';

class RenDetScreen extends StatefulWidget {
  const RenDetScreen({super.key});

  @override
  State<RenDetScreen> createState() => _RenDetScreenState();
}

class _RenDetScreenState extends State<RenDetScreen> {
  MobiliarioDatabase? mobiliarioDB;
  @override
  void initState() {
    super.initState();
    mobiliarioDB = MobiliarioDatabase();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int? rentaId;
    String? nombreRenta;

    if (args != null) {
      rentaId = args['id'];
      nombreRenta = args['nombre'];
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.colorScheme.background,
        title: Text(
          'Detalles: $nombreRenta',
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModal(context, null, rentaId);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: context.theme.colorScheme.background,
      body: ValueListenableBuilder(
        valueListenable: AppValueNotifier.banRentas,
        builder: (context, value, _) {
          return FutureBuilder(
            future: mobiliarioDB!.consultarRentaDetallePorID(rentaId!),
            builder: (context,
                AsyncSnapshot<List<RentaDetalleNombreModel>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Algo salio mal! '),
                );
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showOptions(context, snapshot.data![index],
                                        rentaId);
                                  },
                                  child: RentaDetalleTitle(
                                    detalles: snapshot.data![index],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
            },
          );
        },
      ),
    );
  }

  _showOptions(context, RentaDetalleNombreModel detalles, int? renId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.42,
          width: MediaQuery.of(context).size.width,
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
              ),
              const Spacer(),
              _bottomSheetButton(
                label: "Actualizar",
                onTap: () {
                  showModal(context, detalles, renId);
                },
                clr: primaryClr,
                icon: const Icon(Icons.edit),
              ),
              _bottomSheetButton(
                label: "Borrar",
                onTap: () async {
                  ArtDialogResponse response = await ArtSweetAlert.show(
                    barrierDismissible: false,
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        denyButtonText: "Cancelar",
                        title: "¿Estás seguro?",
                        text: "Esta acción no se puede revertir",
                        confirmButtonText: "Sí, deseo borrar.",
                        type: ArtSweetAlertType.warning),
                  );
                  if (response.isTapConfirmButton) {
                    mobiliarioDB!.eliminarRentaDetalle({
                      "idRenta": renId,
                      "idMobiliario":
                          int.parse(detalles.idMobiliario.toString()),
                    }).then(
                      (value) {
                        if (value > 0) {
                          Navigator.pop(context);
                          ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "!Eliminado!"),
                          );
                          AppValueNotifier.banRentas.value =
                              !AppValueNotifier.banRentas.value;
                        }
                      },
                    );
                    return;
                  }
                },
                clr: primaryClr,
                icon: const Icon(Icons.edit),
              ),
              const SizedBox(
                height: 20,
              ),
              _bottomSheetButton(
                  label: "Cerrar",
                  onTap: () {
                    Navigator.pop(context);
                  },
                  isClose: true,
                  clr: Colors.red[300]!),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    Icon? icon,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: icon,
              ),
            Text(
              label,
              style: isClose
                  ? titleStyle
                  : titleStyle.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  showModal(context, RentaDetalleNombreModel? detalles, int? renId) async {
    List<MobiliarioModel> mobiliarios =
        await mobiliarioDB!.consultarMobiliario();
    List<String> listadoMobiliarios =
        mobiliarios.map((mobiliario) => mobiliario.nombreMobiliario!).toList();
    List<double> listadoPreciosMobiliarios = mobiliarios
        .map((mobiliario) => mobiliario.precioRentaMobiliario!)
        .toList();
    List<int> listadoDisponibilidadMobiliarios = mobiliarios
        .map((mobiliario) => mobiliario.cantidadDisponibleMobiliario!)
        .toList();
    int? _selectedMobiliarioId;
    double? _selectedPrecio;
    int? _selectedCantidad;
    int? _selectedMaxCantidad;
    String _selectedString = "Nada";

    final idRenDetMob = TextEditingController();
    final cantidadDetalle = TextEditingController();
    final precioUnitarioDetalle = TextEditingController();
    if (listadoMobiliarios.isNotEmpty) {
      _selectedString = listadoMobiliarios.first;
      _selectedMobiliarioId = mobiliarios.first.idMobiliario;
      _selectedPrecio = mobiliarios.first.precioRentaMobiliario;
      _selectedMaxCantidad = listadoDisponibilidadMobiliarios.first;
    }
    if (detalles != null) {
      idRenDetMob.text = detalles.idMobiliario.toString();
      cantidadDetalle.text = detalles.cantidadDetalle.toString();
      precioUnitarioDetalle.text = detalles.precioUnitarioDetalle.toString();
      cantidadDetalle.text = detalles.cantidadDetalle.toString();
    }
    const space = SizedBox(
      height: 10,
    );
    final btnAgregar = ElevatedButton.icon(
      onPressed: () {
        if (detalles == null) {
          mobiliarioDB!.insertarRentaDetalle(
            {
              "idRenta": renId,
              "idMobiliario": _selectedMobiliarioId,
              "cantidadDetalle": int.parse(cantidadDetalle.text),
              "precioUnitarioDetalle": double.parse(precioUnitarioDetalle.text)
            },
          ).then(
            (value) {
              Navigator.pop(context);
              String msg = "";
              if (value != null && value is int) {
                if (value > 0) {
                  AppValueNotifier.banRentas.value =
                      !AppValueNotifier.banRentas.value;
                  msg = "Mobiliario Insertado!";
                } else {
                  msg = "Ocurrio un error?";
                }
              } else {
                msg =
                    "Ocurrió un error al procesar la respuesta de la base de datos.";
              }
              var snackbar = SnackBar(content: Text(msg));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
          ).catchError(
            (error) {
              Navigator.pop(context);
              var snackbar = const SnackBar(
                  content: Text(
                      "Ocurrió un error al insertar en la base de datos."));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
          );
        } else {
          if (int.parse(detalles.idMobiliario.toString()) ==
                  _selectedMobiliarioId &&
              int.parse(detalles.cantidadDetalle.toString()) ==
                  int.parse(cantidadDetalle.text)) {
            Navigator.pop(context);
            Navigator.pop(context);
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.info,
                title: "No es necesario actualizar, valores iguales.",
              ),
            );
          } else {
            mobiliarioDB!.actualizaRentaDetalle({
              "idRenta": renId,
              "idMobiliario": int.parse(detalles.idMobiliario.toString())
            }, {
              "idRenta": renId,
              "idMobiliario": _selectedMobiliarioId,
              "cantidadDetalle": int.parse(cantidadDetalle.text),
              "precioUnitarioDetalle": double.parse(precioUnitarioDetalle.text),
            }).then(
              (value) {
                Navigator.pop(context);
                Navigator.pop(context);
                if (value > 0) {
                  AppValueNotifier.banRentas.value =
                      !AppValueNotifier.banRentas.value;
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.success,
                      title: "¡Detalle de renta Actualizado!",
                    ),
                  );
                } else {
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.warning,
                      title: "Ocurrió un error.",
                    ),
                  );
                }
              },
            );
          }
        }
      },
      icon: const Icon(Icons.save),
      label: const Text('Guardar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.66,
          minChildSize: 0.66,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Text(
                        "Añadir Detalle",
                        style: headingStyle,
                      ),
                      InputField(
                        title: "Mobiliario",
                        hint: _selectedString,
                        widget: DropdownButton(
                          value: _selectedString,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          style: subTitleStyle,
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedString = newValue!;
                              _selectedMobiliarioId = mobiliarios
                                  .firstWhere((mobiliario) =>
                                      mobiliario.nombreMobiliario == newValue)
                                  .idMobiliario;
                              _selectedPrecio = listadoPreciosMobiliarios[
                                  listadoMobiliarios.indexOf(newValue)];
                              precioUnitarioDetalle.text =
                                  _selectedPrecio.toString();
                              _selectedMaxCantidad =
                                  listadoDisponibilidadMobiliarios[
                                      listadoMobiliarios.indexOf(newValue)];
                            });
                          },
                          items:
                              listadoMobiliarios.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      space,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: cantidadDetalle,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Asegura que solo se ingresen números
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese una cantidad';
                          }
                          final cantidad = int.tryParse(value);
                          if (cantidad == null) {
                            return 'Por favor ingrese un número entero';
                          }
                          if (cantidad < 1) {
                            return 'La cantidad mínima es 1';
                          }
                          if (_selectedMaxCantidad != null &&
                              cantidad > _selectedMaxCantidad!) {
                            return 'La cantidad máxima es $_selectedMaxCantidad';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Cantidad",
                          hintText: "Maxima Cantidad = $_selectedMaxCantidad",
                        ),
                      ),
                      space,
                      AbsorbPointer(
                        absorbing: true,
                        child: InputField(
                          title: "Precio Unitario",
                          hint: _selectedPrecio != null
                              ? _selectedPrecio.toString()
                              : "",
                          controller: precioUnitarioDetalle,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      space,
                      btnAgregar
                    ],
                  ),
                ),
              );
            });
          }),
    );
  }
}

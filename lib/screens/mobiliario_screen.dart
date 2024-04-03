import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:renta_movil_app/database/mobiliario_database.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:renta_movil_app/screens/app_value_notifier.dart';
import 'package:renta_movil_app/screens/menu_lateral.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/input_field.dart';
import 'package:renta_movil_app/widgets/mobiliario_tile.dart';

class MobiliarioScreen extends StatefulWidget {
  const MobiliarioScreen({super.key});

  @override
  State<MobiliarioScreen> createState() => _MobiliarioScreenState();
}

class _MobiliarioScreenState extends State<MobiliarioScreen> {
  MobiliarioDatabase? mobiliarioDB;
  @override
  void initState() {
    super.initState();
    mobiliarioDB = MobiliarioDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.colorScheme.background,
        title: const Text('Listado de Mobiliarios'),
        actions: [
          IconButton(
            onPressed: () {
              showModal(context, null);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      backgroundColor: context.theme.colorScheme.background,
      drawer: MenuLateral(context),
      body: ValueListenableBuilder(
        valueListenable: AppValueNotifier.banMobiliarios,
        builder: (context, value, _) {
          return FutureBuilder(
            future: mobiliarioDB!.consultarMobiliario(),
            builder: (context, AsyncSnapshot<List<MobiliarioModel>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Algo salio mal! :()'),
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
                                    _showOptions(
                                      context,
                                      snapshot.data![index],
                                    );
                                  },
                                  child: MobiliarioTile(
                                    mobiliario: snapshot.data![index],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  // return Padding(
                  //   padding: const EdgeInsets.all(10.00),
                  //   child: ListView.builder(
                  //     itemCount: snapshot.data!.length,
                  //     itemBuilder: (context, index) {
                  //       return itemMobiliario(snapshot.data![index]);
                  //     },
                  //   ),
                  // );
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

  _showOptions(context, MobiliarioModel mobiliario) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height *
              0.42, //MediaQuery.of(context).size.height * 0.32,
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
                label: "Administrar categorías",
                onTap: () {
                  Navigator.pushNamed(context, "/mobiliarioCategoria");
                },
                clr: primaryClr,
                icon: const Icon(Icons.edit),
              ),
              _bottomSheetButton(
                label: "Actualizar",
                onTap: () {
                  showModal(context, mobiliario);
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
                    mobiliarioDB!
                        .eliminarMobiliario(mobiliario.idMobiliario!)
                        .then(
                      (value) {
                        Navigator.pop(context);
                        if (value > 0) {
                          ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "¡Eliminado!"),
                          );
                          AppValueNotifier.banMobiliarios.value =
                              !AppValueNotifier.banMobiliarios.value;
                        }
                      },
                    );
                    return;
                  }
                },
                clr: Colors.red[300]!,
                icon: const Icon(Icons.delete),
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
                clr: Colors.red[300]!,
              ),
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
            if (icon != null) // Mostrar el icono si está presente
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

  // Widget itemMobiliario(MobiliarioModel mobiliario) {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 10),
  //     decoration: BoxDecoration(
  //       color: context.theme.colorScheme.secondary,
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(
  //         color: Colors.black,
  //         width: 2,
  //       ),
  //     ),
  //     height: 80,
  //     child: Column(
  //       children: [
  //         Text(mobiliario.nombreMobiliario!),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             IconButton(
  //               onPressed: () {
  //                 showModal(context, mobiliario);
  //               },
  //               icon: const Icon(Icons.edit),
  //             ),
  //             IconButton(
  //               onPressed: () async {
  //                 ArtDialogResponse response = await ArtSweetAlert.show(
  //                   barrierDismissible: false,
  //                   context: context,
  //                   artDialogArgs: ArtDialogArgs(
  //                       denyButtonText: "Cancelar",
  //                       title: "Estas seguro?",
  //                       text: "Esto no se puede revertir",
  //                       confirmButtonText: "Si, deseo borrar",
  //                       type: ArtSweetAlertType.warning),
  //                 );
  //                 if (response.isTapConfirmButton) {
  //                   mobiliarioDB!
  //                       .eliminarMobiliario(mobiliario.idMobiliario!)
  //                       .then(
  //                     (value) {
  //                       if (value > 0) {
  //                         ArtSweetAlert.show(
  //                           context: context,
  //                           artDialogArgs: ArtDialogArgs(
  //                               type: ArtSweetAlertType.success,
  //                               title: "Eliminado!"),
  //                         );
  //                         AppValueNotifier.banMobiliarios.value =
  //                             !AppValueNotifier.banMobiliarios.value;
  //                       }
  //                     },
  //                   );
  //                   return;
  //                 }
  //               },
  //               icon: const Icon(Icons.delete),
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  showModal(context, MobiliarioModel? mobiliario) {
    final nmbMobiliario = TextEditingController();
    final cantTotalMobiliario = TextEditingController();
    final cantDispMobiliario = TextEditingController();
    final descMobiliario = TextEditingController();
    final precioRentaMobiliario = TextEditingController();

    if (mobiliario != null) {
      nmbMobiliario.text = mobiliario.nombreMobiliario!;
      cantTotalMobiliario.text = mobiliario.cantidadTotalMobiliario!.toString();
      cantDispMobiliario.text =
          mobiliario.cantidadDisponibleMobiliario!.toString();
      descMobiliario.text = mobiliario.descripcionMobiliario!;
      precioRentaMobiliario.text = mobiliario.precioRentaMobiliario!.toString();
    }
    const space = SizedBox(
      height: 10,
    );
    final btnAgregar = ElevatedButton.icon(
      onPressed: () {
        if (mobiliario == null) {
          mobiliarioDB!.insertarMobiliario(
            {
              "nombreMobiliario": nmbMobiliario.text,
              "cantidadTotalMobiliario": int.parse(cantTotalMobiliario.text),
              "cantidadDisponibleMobiliario":
                  int.parse(cantDispMobiliario.text),
              "descripcionMobiliario": descMobiliario.text,
              "precioRentaMobiliario": double.parse(precioRentaMobiliario.text),
            },
          ).then(
            (value) {
              Navigator.pop(context);
              String msg = "";
              if (value > 0) {
                AppValueNotifier.banMobiliarios.value =
                    !AppValueNotifier.banMobiliarios.value;
                msg = "Mobiliario Insertado!";
              } else {
                msg = "Ocurrio un error :()";
              }
              var snackbar = SnackBar(content: Text(msg));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
          );
        } else {
          mobiliarioDB!.actualizarMobiliario(
            {
              "idMobiliario": mobiliario.idMobiliario,
              "nombreMobiliario": nmbMobiliario.text,
              "cantidadTotalMobiliario": int.parse(cantTotalMobiliario.text),
              "cantidadDisponibleMobiliario":
                  int.parse(cantDispMobiliario.text),
              "descripcionMobiliario": descMobiliario.text,
              "precioRentaMobiliario": double.parse(precioRentaMobiliario.text),
            },
          ).then(
            (value) {
              Navigator.pop(context);
              //String msg = "";
              if (value > 0) {
                AppValueNotifier.banMobiliarios.value =
                    !AppValueNotifier.banMobiliarios.value;
                ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.success,
                      title: "¡Mobiliario Actualizado!"),
                );
                // msg = "Mobiliario actualizado!";
              } else {
                ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.warning,
                      title: "Ocurrió un error."),
                );
                // msg = "Ocurrio un error :()";
              }
              // var snackbar = SnackBar(content: Text(msg));
              // ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
          );
        }
      },
      icon: const Icon(Icons.save),
      label: const Text('Guardar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        //foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          children: [
            Text(
              "Añadir Mobiliario",
              style: headingStyle,
            ),
            InputField(
              title: "Nombre",
              hint: "Nombre del mobiliario",
              controller: nmbMobiliario,
            ),
            InputField(
              title: "Cantidad Total",
              hint: "Cantidad total del mobiliario",
              controller: cantTotalMobiliario,
              keyboardType: TextInputType.number,
            ),
            InputField(
              title: "Cantidad Disponible",
              hint: "Cantidad disponible del mobiliario",
              controller: cantDispMobiliario,
              keyboardType: TextInputType.number,
            ),
            InputField(
              title: "Descripción",
              hint: "Descripción del mobiliario",
              controller: descMobiliario,
            ),
            InputField(
              title: "Precio de renta",
              hint: "Precio de renta del mobiliario",
              controller: precioRentaMobiliario,
              keyboardType: TextInputType.number,
            ), //txtNombreCategoria,
            space,
            btnAgregar
          ],
        );
      },
    );
  }
}

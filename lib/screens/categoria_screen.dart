import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:renta_movil_app/database/mobiliario_database.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:get/get.dart';
import 'package:renta_movil_app/screens/app_value_notifier.dart';
import 'package:renta_movil_app/screens/menu_lateral.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/categoria_tile.dart';
import 'package:renta_movil_app/widgets/input_field.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
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
        title: const Text('Listado de Categorías'),
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
        valueListenable: AppValueNotifier.banCategorias,
        builder: (context, value, _) {
          return FutureBuilder(
            future: mobiliarioDB!.consultarCategoria(),
            builder: (context, AsyncSnapshot<List<CategoriaModel>> snapshot) {
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
                                  child: CategoriaTile(
                                    categoria: snapshot.data![index],
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

  _showOptions(context, CategoriaModel categoria) {
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
                label: "Actualizar",
                onTap: () {
                  showModal(context, categoria);
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
                        confirmButtonText: "Sí, deseo borrar",
                        type: ArtSweetAlertType.warning),
                  );
                  if (response.isTapConfirmButton) {
                    mobiliarioDB!
                        .eliminarCategoria(categoria.idCategoria!)
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
                          AppValueNotifier.banCategorias.value =
                              !AppValueNotifier.banCategorias.value;
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

  showModal(context, CategoriaModel? categoria) {
    final nmbCategoria = TextEditingController();

    if (categoria != null) {
      nmbCategoria.text = categoria.nombreCategoria!;
    }
    const space = SizedBox(
      height: 10,
    );
    final btnAgregar = ElevatedButton.icon(
      onPressed: () {
        if (categoria == null) {
          mobiliarioDB!.insertarCategoria(
            {
              "nombreCategoria": nmbCategoria.text,
            },
          ).then(
            (value) {
              Navigator.pop(context);
              String msg = "";
              if (value > 0) {
                AppValueNotifier.banCategorias.value =
                    !AppValueNotifier.banCategorias.value;
                msg = "¡Categoría Insertada!";
              } else {
                msg = "Ocurrio un error :()";
              }
              var snackbar = SnackBar(content: Text(msg));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
          );
        } else {
          mobiliarioDB!.actualizarCategoria(
            {
              "idCategoria": categoria.idCategoria,
              "nombreCategoria": nmbCategoria.text,
            },
          ).then(
            (value) {
              Navigator.pop(context);
              //String msg = "";
              if (value > 0) {
                AppValueNotifier.banCategorias.value =
                    !AppValueNotifier.banCategorias.value;
                ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.success,
                      title: "¡Categoría Actualizada!"),
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
              "Añadir Categoría",
              style: headingStyle,
            ),
            InputField(
              title: "Nombre",
              hint: "Nombre de la categoría",
              controller: nmbCategoria,
            ),
            space,
            btnAgregar
          ],
        );
      },
    );
  }
}

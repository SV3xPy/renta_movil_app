import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:renta_movil_app/database/mobiliario_database.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:renta_movil_app/screens/app_value_notifier.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/input_field.dart';
import 'package:renta_movil_app/widgets/mobiliario_categoria_title.dart';
import 'package:badges/badges.dart' as badges;

class MobCatScreen extends StatefulWidget {
  const MobCatScreen({super.key});

  @override
  State<MobCatScreen> createState() => _MobCatScreenState();
}

class _MobCatScreenState extends State<MobCatScreen> {
  MobiliarioDatabase? mobiliarioDB;
  @override
  void initState() {
    super.initState();
    mobiliarioDB = MobiliarioDatabase();
  }

  @override
  Widget build(BuildContext context) {
    int? mobiliarioId = ModalRoute.of(context)?.settings.arguments as int?;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.colorScheme.background,
        title: const Text('Categorías de Mobiliarios'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModal(context, null, mobiliarioId);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      backgroundColor: context.theme.colorScheme.background,
      body: ValueListenableBuilder(
        valueListenable: AppValueNotifier.banMobiliarios,
        builder: (context, value, _) {
          return FutureBuilder(
            future:
                mobiliarioDB!.consultarMobilarioCategoriaPorID(mobiliarioId!),
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
                                    _showOptions(context, snapshot.data![index],
                                        mobiliarioId);
                                  },
                                  child: MobiliarioCategoriaTitle(
                                    //Está en la carpeta Widgets, crear nuevo archivo y ajustarlo de acuerdo a la información que quieras mostrar.
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

  _showOptions(context, CategoriaModel mobcat, int? mobId) {
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
                  showModal(context, mobcat, mobId);
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
                    mobiliarioDB!.eliminarMobiliarioCategoria({
                      "idMobiliario": mobId,
                      "idCategoria": int.parse(mobcat.idCategoria.toString()),
                    }).then(
                      (value) {
                        if (value > 0) {
                          Navigator.pop(context);
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

  showModal(context, CategoriaModel? mobcat, int? mobId) async {
    List<CategoriaModel> categorias = await mobiliarioDB!.consultarCategoria();
    List<String> listadoCategorias =
        categorias.map((categoria) => categoria.nombreCategoria!).toList();
    //Para almacenar la categoria seleccionado del listado
    int? selectedCategoriaId;
    String _selectedString = "Nada";
    final idCatMobCat = TextEditingController();
    //final idMobMobCat = TextEditingController();
    if (listadoCategorias.isNotEmpty) {
      //Si vamos a insertar entonces que el default sea
      //el primer elemento
      _selectedString = listadoCategorias.first;
      selectedCategoriaId = categorias.first.idCategoria;
    }

    if (mobcat != null) {
      idCatMobCat.text = mobcat.idCategoria.toString();
      //idMobMobCat.text = mobId.toString();
    }
    const space = SizedBox(
      height: 10,
    );

    final btnAgregar = badges.Badge(
      badgeContent: Text('25'),
      child: ElevatedButton.icon(
        onPressed: () {
          if (mobcat == null) {
            mobiliarioDB!.insertarMobiliarioCategoria(
              {
                "idMobiliario": mobId,
                "idCategoria": selectedCategoriaId,
              },
            ).then(
              (value) {
                Navigator.pop(context);
                String msg = "";
                if (value != null && value is int) {
                  if (value > 0) {
                    AppValueNotifier.banMobiliarios.value =
                        !AppValueNotifier.banMobiliarios.value;
                    msg = "Mobiliario Insertado!";
                  } else {
                    msg = "Ocurrió un error :(";
                  }
                } else {
                  msg =
                      "Ocurrió un error al procesar la respuesta de la base de datos.";
                }
                var snackbar = SnackBar(content: Text(msg));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              },
            ).catchError((error) {
              Navigator.pop(context);
              var snackbar = const SnackBar(
                  content: Text(
                      "Ocurrió un error al insertar en la base de datos."));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
          } else {
            if (int.parse(mobcat.idCategoria.toString()) ==
                selectedCategoriaId) {
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
              mobiliarioDB!.actualizarMobiliarioCategoria({
                //Primero los datos anteriores
                "idMobiliario": mobId,
                "idCategoria": int.parse(mobcat.idCategoria.toString()),
              }, {
                //Y lo valores nuevos
                "idMobiliario": mobId,
                "idCategoria": selectedCategoriaId
              }).then(
                (value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //String msg = "";
                  if (value > 0) {
                    AppValueNotifier.banMobiliarios.value =
                        !AppValueNotifier.banMobiliarios.value;
                    ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.success,
                        title: "¡Mobiliario Actualizado!",
                      ),
                    );
                    // msg = "Mobiliario actualizado!";
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
          //foregroundColor: Theme.of(context).colorScheme.secondary,
        ),
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
                        "Añadir Mobiliario",
                        style: headingStyle,
                      ),
                      InputField(
                        title: "Categoría",
                        hint: _selectedString,
                        widget: DropdownButton(
                          value:
                              _selectedString, // Valor seleccionado actualmente
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
                              // Aquí puedes buscar el idCategoria correspondiente al nombre seleccionado
                              // y actualizar selectedCategoriaId
                              selectedCategoriaId = categorias
                                  .firstWhere((categoria) =>
                                      categoria.nombreCategoria == newValue)
                                  .idCategoria;
                            });
                          },
                          items:
                              listadoCategorias.map<DropdownMenuItem<String>>(
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
                      btnAgregar
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

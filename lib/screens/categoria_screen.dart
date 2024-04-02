import 'package:flutter/material.dart';
import 'package:renta_movil_app/database/mobiliario_database.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:get/get.dart';
import 'package:renta_movil_app/screens/app_value_notifier.dart';
import 'package:renta_movil_app/screens/menu_lateral.dart';
import 'package:renta_movil_app/settings/theme.dart';

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
                  return Padding(
                    padding: const EdgeInsets.all(10.00),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return itemCategoria(snapshot.data![index]);
                      },
                    ),
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

  Widget itemCategoria(CategoriaModel categoria) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      height: 80,
      child: Column(
        children: [
          Text(categoria.nombreCategoria!),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    showModal(context, categoria);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                onPressed: () async {
                  ArtDialogResponse response = await ArtSweetAlert.show(
                      barrierDismissible: false,
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          denyButtonText: "Cancelar",
                          title: "Estas seguro?",
                          text: "Esto no se puede revertir",
                          confirmButtonText: "Si, deseo borrar",
                          type: ArtSweetAlertType.warning));
                  if (response.isTapConfirmButton) {
                    mobiliarioDB!
                        .eliminarCategoria(categoria.idCategoria!)
                        .then((value) {
                      if (value > 0) {
                        ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Eliminado!"));
                        AppValueNotifier.banCategorias.value =
                            !AppValueNotifier.banCategorias.value;
                      }
                    });
                    return;
                  }
                },
                icon: const Icon(Icons.delete),
              )
            ],
          )
        ],
      ),
    );
  }

  showModal(context, CategoriaModel? categoria) {
    final conNombreCategorias = TextEditingController();
    if (categoria != null) {
      conNombreCategorias.text = categoria.nombreCategoria!;
    }
    final txtNombreCategoria = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombreCategorias,
      decoration: InputDecoration(
        labelText: 'Nombre',
        border: const OutlineInputBorder(),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        hintText: 'Nombre de la Categoria',
      ),
    );
    const space = SizedBox(
      height: 10,
    );
    final btnAgregar = ElevatedButton.icon(
      onPressed: () {
        if (categoria == null) {
          mobiliarioDB!.insertarCategoria(
              {"nombreCategoria": conNombreCategorias.text}).then((value) {
            Navigator.pop(context);
            String msg = "";
            if (value > 0) {
              AppValueNotifier.banCategorias.value =
                  !AppValueNotifier.banCategorias.value;
              msg = "Categoria Insertada !";
            } else {
              msg = "Ocurrio un error :()";
            }
            var snackbar = SnackBar(content: Text(msg));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          });
        } else {
          mobiliarioDB!.actualizarCategoria({
            "idCategoria": categoria.idCategoria,
            "nombreCategoria": conNombreCategorias.text
          }).then((value) {
            Navigator.pop(context);
            String msg = "";
            if (value > 0) {
              AppValueNotifier.banCategorias.value =
                  !AppValueNotifier.banCategorias.value;
              msg = "Categoria actualizada!";
            } else {
              msg = "Ocurrio un error :()";
            }
            var snackbar = SnackBar(content: Text(msg));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          });
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
                "Añadir Categoria",
                style: headingStyle,
              ),
              txtNombreCategoria,
              space,
              btnAgregar
            ],
          );
        });
  }
}

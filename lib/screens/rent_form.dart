import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renta_movil_app/database/mobiliario_database.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:renta_movil_app/screens/app_value_notifier.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/add_rent_button.dart';
import 'package:renta_movil_app/widgets/input_field.dart';

class RentForm extends StatefulWidget {
  final RentaModel? renta;
  const RentForm({super.key, this.renta});

  @override
  State<RentForm> createState() => _RentFormState();
}

class _RentFormState extends State<RentForm> {
  MobiliarioDatabase? mobiliarioDB;
  final TextEditingController _nmbController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dirController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final TextEditingController _fechaEntregaController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime(2099, 12, 31);
  DateTime _deliverDate = DateTime(2099, 12, 31);
  int _selectedValue = 5;
  List<int> exampleValues = [5, 10, 15, 20];
  String? _selectedString = "-----";
  int _selectedStatusID = -1;
  List<String> exampleString = ["Ejemplo1", "Ejemplo2", "Ejemplo3", "Ejemplo4"];
  //int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    mobiliarioDB = MobiliarioDatabase();
  }

  Future<List<StatusModel>> _fetchStatuses() async {
    final List<StatusModel> data = await mobiliarioDB!.consultarStatus();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final renta = ModalRoute.of(context)!.settings.arguments as RentaModel?;
    if (renta != null) {
      _nmbController.text = renta.nombreRenta!;
      _dirController.text = renta.direccionRenta!;
      _telController.text = renta.telefonoRenta!;
      _montoController.text = renta.montoRenta!.toString();
      _fechaInicioController.text =
          renta.fechaInicioRenta!; //DateFormat.yMd().format(_startDate);
      _fechaFinController.text = renta.fechaFinRenta!;
      _fechaEntregaController.text = renta.fechaEntregaRenta!;
      print("VALOR INICIAL: ${_fechaInicioController.text}");
      _selectedStatusID = renta.idStatus!;
    }
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Añadir Renta",
                style: headingStyle,
              ),
              InputField(
                title: "Nombre",
                hint: "Nombre de la renta.",
                controller: _nmbController,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Fecha Inicio",
                      hint: _fechaInicioController.text,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDateFromUser(
                              isStartDate: true,
                              isDeliverDate: false,
                              context: context);
                        },
                      ),
                      controller: _fechaInicioController,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "Fecha Fin",
                      hint: _fechaFinController.text,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          print("SE ACTUALIZÓ: $_endDate");
                          _getDateFromUser(
                              isStartDate: false,
                              isDeliverDate: false,
                              context: context);
                        },
                      ),
                      controller: _fechaFinController,
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Fecha de Entrega",
                hint: _fechaEntregaController
                    .text, //DateFormat.yMd().format(_deliverDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    print("SE ACTUALIZÓ: $_deliverDate");
                    _getDateFromUser(
                        isStartDate: false,
                        isDeliverDate: true,
                        context: context);
                  },
                ),
                controller: _fechaEntregaController,
              ),
              InputField(
                title: "Dirección",
                hint: "Dirección de la renta.",
                controller: _dirController,
              ),
              InputField(
                title: "Teléfono",
                hint: "Teléfono de la renta.",
                keyboardType: TextInputType.phone,
                controller: _telController,
              ),
              InputField(
                title: "Monto",
                hint: "Monto de la renta.",
                keyboardType: TextInputType.number,
                controller: _montoController,
              ),
              InputField(
                //Ejemplo, es para tener una guía por si en algún formulario se ocupan Dropdowns
                title: "Status",
                hint: _selectedString!,
                widget: FutureBuilder<List<StatusModel>>(
                  future: _fetchStatuses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButton<StatusModel>(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        style: subTitleStyle,
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (StatusModel? newValue) {
                          setState(() {
                            _selectedString = newValue!.nombreStatus;
                            _selectedStatusID = newValue.idStatus!;
                          });
                        },
                        items:
                            snapshot.data!.map<DropdownMenuItem<StatusModel>>(
                          (StatusModel value) {
                            return DropdownMenuItem<StatusModel>(
                              value: value,
                              child: Text(value.nombreStatus!),
                            );
                          },
                        ).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center /*MainAxisAlignment.spaceBetween*/,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //_colorPallete(),
                  AddRent(
                    label: "Añadir renta",
                    onTap: () => _validateFields(renta),
                  )
                ],
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  _getDateFromUser({
    required bool isStartDate,
    required bool isDeliverDate,
    required BuildContext context,
  }) async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2099),
    );

    if (pickerDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickerDate);
      setState(() {
        if (isStartDate) {
          //_startDate = pickerDate;
          print("FECHA FORMATEADO: $formattedDate");
          _fechaInicioController.text = formattedDate;
          print("FECHA CONTROLADOR: ${_fechaInicioController.text}");
        } else if (isDeliverDate) {
          //_deliverDate = pickerDate;
          _fechaEntregaController.text = formattedDate;
        } else {
          //_endDate = pickerDate;
          _fechaFinController.text = formattedDate;
        }
      });
    } else {
      print("Algo salió mal.");
    }
  }

  _validateFields(RentaModel? renta) {
    if (_nmbController.text.isNotEmpty &&
        _dirController.text.isNotEmpty &&
        _telController.text.isNotEmpty &&
        _montoController.text.isNotEmpty &&
        !_selectedStatusID.isNegative) {
      if (renta == null) {
        mobiliarioDB!.insertarRenta(
          {
            "fechaInicioRenta": _fechaInicioController
                .text, //DateFormat.yMd().format(_startDate), //,
            "fechaFinRenta": _fechaFinController.text,
            "fechaEntregaRenta": _fechaEntregaController.text,
            "nombreRenta": _nmbController.text,
            "telefonoRenta": _telController.text,
            "direccionRenta": _dirController.text,
            "montoRenta": double.parse(_montoController.text),
            "idStatus": _selectedStatusID
          },
        ).then(
          (value) {
            Navigator.pop(context);
            String msg = "";
            if (value > 0) {
              AppValueNotifier.banRentas.value =
                  !AppValueNotifier.banRentas.value;
              msg = "¡Renta Insertada!";
            } else {
              msg = "Ocurrio un error :()";
            }
            var snackbar = SnackBar(content: Text(msg));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          },
        );
      } else {
        mobiliarioDB!.actualizarRenta(
          {
            "idRenta": renta.idRenta,
            "fechaInicioRenta": _fechaInicioController
                .text, //DateFormat.yMd().format(_startDate),
            "fechaFinRenta": _fechaFinController.text,
            "fechaEntregaRenta": _fechaEntregaController.text,
            "nombreRenta": _nmbController.text,
            "telefonoRenta": _telController.text,
            "direccionRenta": _dirController.text,
            "montoRenta": double.parse(_montoController.text),
            "idStatus": _selectedStatusID
          },
        ).then(
          (value) {
            Navigator.pop(context);
            //String msg = "";
            if (value > 0) {
              AppValueNotifier.banRentas.value =
                  !AppValueNotifier.banRentas.value;
              ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.success,
                    title: "¡Renta Actualizada!"),
              );
            } else {
              ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.warning,
                    title: "Ocurrió un error."),
              );
            }
          },
        );
      }
    } else if (_nmbController.text.isEmpty ||
        _dirController.text.isEmpty ||
        _telController.text.isEmpty ||
        _montoController.text.isEmpty ||
        _selectedStatusID.isNegative) {
      Get.snackbar(
        "Requerido",
        "¡Todos los campos son obligatorios!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }
}

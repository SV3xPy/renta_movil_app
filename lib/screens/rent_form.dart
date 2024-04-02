import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/add_rent_button.dart';
import 'package:renta_movil_app/widgets/input_field.dart';

class RentForm extends StatefulWidget {
  const RentForm({super.key});

  @override
  State<RentForm> createState() => _RentFormState();
}

class _RentFormState extends State<RentForm> {
  final TextEditingController _nmbController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dirController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime(2099, 12, 31);
  int _selectedValue = 5;
  List<int> exampleValues = [5, 10, 15, 20];
  String _selectedString = "Nada";
  List<String> exampleString = ["Ejemplo1", "Ejemplo2", "Ejemplo3", "Ejemplo4"];
  //int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
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
              InputField(
                title: "Descripción",
                hint: "Descripción de la renta.",
                controller: _descController,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Fecha Inicio",
                      hint: DateFormat.yMd().format(_startDate),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDateFromUser(isStartDate: true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "Fecha Fin",
                      hint: DateFormat.yMd().format(_endDate),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDateFromUser(isStartDate: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Fecha de Entrega",
                hint: DateFormat.yMd().format(_startDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser(isStartDate: true);
                  },
                ),
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
                title: "Ejemplo Dropdown",
                hint: "$_selectedValue Ejemplo",
                widget: DropdownButton(
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
                      _selectedValue = int.parse(newValue!);
                    });
                  },
                  items: exampleValues.map<DropdownMenuItem<String>>(
                    (int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              InputField(
                //Ejemplo, es para tener una guía por si en algún formulario se ocupan Dropdowns
                title: "Ejemplo Dropdown 2",
                hint: "$_selectedString Ejemplo",
                widget: DropdownButton(
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
                    });
                  },
                  items: exampleString.map<DropdownMenuItem<String>>(
                    (String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ).toList(),
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
                  AddRent(label: "Añadir renta", onTap: () => _validateFields())
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

  _getDateFromUser({required bool isStartDate}) async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2099),
    );

    if (_pickerDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = _pickerDate;
          print(_startDate); //OJO:2024-03-31 00:00:00.000
        } else {
          _endDate = _pickerDate;
        }
      });
    } else {
      print("Algo salió mal.");
    }
  }

  // _colorPallete() {
  //   //Si se quieren añadir colores, una tabla debe tener un campo int donde se almacene.
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Colores",
  //         style: titleStyle,
  //       ),
  //       const SizedBox(
  //         height: 8,
  //       ),
  //       Wrap(
  //         children: List<Widget>.generate(
  //           3,
  //           (int index) {
  //             return GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   _selectedColor = index;
  //                 });
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.only(right: 8.0),
  //                 child: CircleAvatar(
  //                   radius: 14,
  //                   backgroundColor: index == 0
  //                       ? primaryClr
  //                       : index == 1
  //                           ? pinkClr
  //                           : yellowClr,
  //                   child: _selectedColor == index
  //                       ? const Icon(
  //                           Icons.done,
  //                           color: Colors.white,
  //                           size: 16,
  //                         )
  //                       : Container(),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }

  _validateFields() {
    if (_nmbController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _dirController.text.isNotEmpty &&
        _telController.text.isNotEmpty &&
        _montoController.text.isNotEmpty) {
      //Añadir a la base de datos
      Get.back();
    } else if (_nmbController.text.isEmpty ||
        _descController.text.isEmpty ||
        _dirController.text.isEmpty ||
        _telController.text.isEmpty ||
        _montoController.text.isEmpty) {
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

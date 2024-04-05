import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:renta_movil_app/database/mobiliario_database.dart';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:renta_movil_app/screens/app_value_notifier.dart';
import 'package:renta_movil_app/screens/menu_lateral.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/add_rent_button.dart';
import 'package:renta_movil_app/widgets/renta_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  MobiliarioDatabase? mobiliarioDB;

  @override
  void initState() {
    super.initState();
    mobiliarioDB = MobiliarioDatabase();
  }

  Future<List<RentaModel>> _fetchRentas() async {
    final List<RentaModel> data = await mobiliarioDB!.consultarRenta();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    print(Get.isDarkMode);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      drawer: MenuLateral(context),
      body: Column(
        children: [
          _addRentBar(),
          _addCalendar(),
          _rentList(),
        ],
      ),
    );
  }

  _addCalendar() {
    return ValueListenableBuilder(
      valueListenable: AppValueNotifier.banRentas,
      builder: (context, value, _) {
        return FutureBuilder(
          future: _fetchRentas(),
          builder: (context, AsyncSnapshot<List<RentaModel>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Algo salio mal! :()'),
              );
            } else {
              if (snapshot.hasData) {
                List<DateTime> rentasFechas = snapshot.data!.map((renta) {
                  // Convertir rentaFechaInicio de String a DateTime
                  DateTime fechas =
                      DateFormat('yyyy-MM-dd').parse(renta.fechaInicioRenta!);
                  return fechas;
                }).toList();
                final eventMap = Map<DateTime, List<RentaModel>>();
                for (var i = 0; i < rentasFechas.length; i++) {
                  DateTime fecha = rentasFechas[i];
                  RentaModel renta =
                      snapshot.data![i]; // Obtener la renta correspondiente
                  final key = DateTime(fecha.year, fecha.month, fecha.day);
                  if (eventMap.containsKey(key)) {
                    eventMap[key]!.add(renta);
                  } else {
                    eventMap[key] = [renta];
                  }
                }
                return TableCalendar(
                  locale: 'es_MX',
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Mes',
                    CalendarFormat.twoWeeks: '2 Semanas',
                    CalendarFormat.week: 'Semana'
                  },
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(1900),
                  lastDay: DateTime.utc(2099),
                  calendarFormat: _calendarFormat,
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    defaultTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: primaryClr,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: Color(0xFF6191E6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 17.5,
                      ),
                    ),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    formatButtonShowsNext: false,
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    //if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    List<RentaModel> events = eventMap[DateTime(
                            selectedDay.year,
                            selectedDay.month,
                            selectedDay.day)] ??
                        [];
                    if (events.isNotEmpty) {
                      _showModal(events);
                    }
                    //}
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: (day) =>
                      eventMap[DateTime(day.year, day.month, day.day)] ?? [],
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      if (day.weekday == DateTime.sunday ||
                          day.weekday == DateTime.saturday) {
                        return Center(
                          child: Text(
                            DateFormat.E('es_MX').format(day),
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            DateFormat.E('es_MX').format(day),
                          ),
                        );
                      }
                    },
                    markerBuilder: (context, day, events) {
                      print(events);
                      if (events.isNotEmpty) {
                        return Stack(
                          children: [
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${events.length}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return null;
                      }
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
    );
    // return TableCalendar(
    //   locale: 'es_MX',
    //   availableCalendarFormats: const {
    //     CalendarFormat.month: 'Mes',
    //     CalendarFormat.twoWeeks: '2 Semanas',
    //     CalendarFormat.week: 'Semana'
    //   },
    //   focusedDay: _focusedDay,
    //   firstDay: DateTime.utc(1900),
    //   lastDay: DateTime.utc(2099),
    //   calendarFormat: _calendarFormat,
    //   calendarStyle: CalendarStyle(
    //     weekendTextStyle: GoogleFonts.lato(
    //       textStyle: const TextStyle(
    //         fontWeight: FontWeight.w600,
    //         color: Colors.red,
    //       ),
    //     ),
    //     defaultTextStyle: GoogleFonts.lato(
    //       textStyle: const TextStyle(
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //     selectedDecoration: const BoxDecoration(
    //       color: primaryClr,
    //       shape: BoxShape.circle,
    //     ),
    //     todayDecoration: const BoxDecoration(
    //       color: Color(0xFF6191E6),
    //       shape: BoxShape.circle,
    //     ),
    //   ),
    //   headerStyle: HeaderStyle(
    //     titleCentered: true,
    //     titleTextStyle: GoogleFonts.lato(
    //       textStyle: const TextStyle(
    //         fontSize: 17.5,
    //       ),
    //     ),
    //     formatButtonDecoration: BoxDecoration(
    //       color: Colors.orange,
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //     formatButtonShowsNext: false,
    //   ),
    //   selectedDayPredicate: (day) {
    //     return isSameDay(_selectedDay, day);
    //   },
    //   onDaySelected: (selectedDay, focusedDay) {
    //     if (!isSameDay(_selectedDay, selectedDay)) {
    //       setState(() {
    //         _selectedDay = selectedDay;
    //         _focusedDay = focusedDay;
    //       });
    //     }
    //   },
    //   onFormatChanged: (format) {
    //     if (_calendarFormat != format) {
    //       setState(() {
    //         _calendarFormat = format;
    //       });
    //     }
    //   },
    //   onPageChanged: (focusedDay) {
    //     _focusedDay = focusedDay;
    //   },
    //   calendarBuilders: CalendarBuilders(
    //     dowBuilder: (context, day) {
    //       if (day.weekday == DateTime.sunday ||
    //           day.weekday == DateTime.saturday) {
    //         return Center(
    //           child: Text(
    //             DateFormat.E('es_MX').format(day),
    //             style: const TextStyle(color: Colors.red),
    //           ),
    //         );
    //       } else {
    //         return Center(
    //           child: Text(
    //             DateFormat.E('es_MX').format(day),
    //           ),
    //         );
    //       }
    //     },
    //   ),
    // );
  }

  _showModal(List<RentaModel> events) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: events.length,
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
                          // _showOptions(
                          //   context,
                          //   snapshot.data![index],
                          // );
                        },
                        child: RentaTile(
                          renta: events[index],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _addRentBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd('es_ES').format(
                    DateTime.now(),
                  ),
                  style: subHeadingStyle,
                ),
                Text(
                  "Hoy",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          //AddRent(label: "Añadir Renta", onTap: () => Get.to(RentForm())),
          AddRent(
            label: "Añadir Renta",
            onTap: () => Navigator.pushNamed(context, "/rentForm"),
          ),
        ],
      ),
    );
  }

  _rentList() {
    return ValueListenableBuilder(
      valueListenable: AppValueNotifier.banRentas,
      builder: (context, value, _) {
        return FutureBuilder(
          future: _fetchRentas(),
          builder: (context, AsyncSnapshot<List<RentaModel>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Algo salio mal! :()'),
              );
            } else {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
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
                                  child: RentaTile(
                                    renta: snapshot.data![index],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
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
    );
  }

  _showOptions(context, RentaModel renta) {
    print("DASHBOARD RENTA: $renta");
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
                  Navigator.pushNamed(
                    context,
                    "/rentForm",
                    arguments: renta,
                  );
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
                    mobiliarioDB!.eliminarRenta(renta.idRenta!).then(
                      (value) {
                        Navigator.pop(context);
                        if (value > 0) {
                          ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "¡Eliminado!"),
                          );
                          AppValueNotifier.banRentas.value =
                              !AppValueNotifier.banRentas.value;
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

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      title: const Text('Dashboard'),
    );
  }
}

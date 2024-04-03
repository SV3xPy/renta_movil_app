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
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
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
      ),
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
              onTap: () => Navigator.pushNamed(context, "/rentForm")),
        ],
      ),
    );
  }

  _rentList() {
    return ValueListenableBuilder(
      valueListenable: AppValueNotifier.banRentas,
      builder: (context, value, _) {
        return FutureBuilder(
          future: mobiliarioDB!.consultarRenta(),
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
                                    // _showOptions(
                                    //   context,
                                    //   snapshot.data![index],
                                    // );
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

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      title: const Text('Dashboard'),
    );
  }
}

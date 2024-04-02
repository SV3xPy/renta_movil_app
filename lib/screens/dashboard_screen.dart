import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:renta_movil_app/screens/rent_form.dart';
import 'package:renta_movil_app/services/theme_services.dart';
import 'package:renta_movil_app/settings/theme.dart';
import 'package:renta_movil_app/widgets/add_rent_button.dart';
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
  @override
  Widget build(BuildContext context) {
    print(Get.isDarkMode);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      drawer: Drawer(
        child: Stack(
          children: [
            ListView(
              children: [
                DrawerHeader(
                  child: Container(),
                ),
                const ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Rentas'),
                  subtitle: Text('Gestión de rentas.'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  ThemeService().switchTheme();
                },
                child: Icon(
                  Get.isDarkMode
                      ? Icons.brightness_high_rounded
                      : Icons.nightlight_round,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          _addRentBar(),
          _addCalendar(),
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
          AddRent(label: "Añadir Renta", onTap: () => Get.to(RentForm()))
        ],
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

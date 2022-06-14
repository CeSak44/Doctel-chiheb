import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/Page/Docter_Profil/invoice_pdf/ordonnance.dart';
import 'package:cote_pat/Page/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../homepage.dart';
import '../Docter_Profil/const.dart';
import '../Docter_Profil/invoice_pdf/pdf_invoice_api.dart';
import '../Docter_Profil/profil_page.dart';
import 'all_mes_rdvs.dart';
import 'constants.dart';

class AllMesrdvToWork extends StatefulWidget {
  const AllMesrdvToWork({
    Key? key,
  }) : super(key: key);

  @override
  State<AllMesrdvToWork> createState() => BoodyAllMesRdvs();
}

class BoodyAllMesRdvs extends State<AllMesrdvToWork> {
  @override
  void initState() {
    getPApp();

    super.initState();
  }

  List<int> disabledIndexv2 = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (doctors.isEmpty) {
      return Container(
        color: bcgcolor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TableCalendar(
                enabledDayPredicate: (day) =>
                    !(day.weekday == 5), //cant click friday
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      // DateTime dateTime = DateTime.now();
                      //   print(dateTime.timeZoneName);
                      //  print(dateTime.timeZoneOffset);
                      iday = DateTime(
                          selectedDay.year, selectedDay.month, selectedDay.day);
                      // print( 'day ${selectedDay.day}-${selectedDay.month}-${selectedDay.year} selected');
                      searchpp();

                      //  print('*************************');
                      //  print('$iday is selected');
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                calendarStyle: CalendarStyle(
                  todayTextStyle: const TextStyle(color: todayTextColorC),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: borderColorC),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: selectedDayColorC,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  defaultDecoration: boxDecoC,
                  weekendDecoration: boxDecoC,
                  rangeStartDecoration: boxDecoC,
                  rowDecoration: boxDecoC,
                  markerDecoration: boxDecoC,
                  holidayDecoration: boxDecoC,
                  outsideDecoration: boxDecoC,
                  rangeEndDecoration: boxDecoC,
                  disabledDecoration: boxDecoC,
                  withinRangeDecoration: boxDecoC,
                ),
                // availableCalendarFormats:,
                calendarFormat: CalendarFormat.week,
                availableCalendarFormats: const {
                  CalendarFormat.week: 'Week',
                },
                startingDayOfWeek: StartingDayOfWeek.saturday,
                weekendDays: const [DateTime.friday],
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2022, 5,
                    5), //DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                lastDay: DateTime.utc(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day + 5)),
            SizedBox(
              height: h * 0.09,
            ),
            Image.asset(
              'assets/images/isEmpty.png',
              scale: 2,
            ),
            Text(
              "You don't have any appoitment on \n ${iday.day} - ${iday.month} - ${iday.year} !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            )
          ],
        ),
      );
    }
    return Container(
      color: bcgcolor,
      child: Column(
        children: [
          TableCalendar(
              enabledDayPredicate: (day) =>
                  !(day.weekday == 5), //cant click friday
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    // DateTime dateTime = DateTime.now();
                    //   print(dateTime.timeZoneName);
                    //  print(dateTime.timeZoneOffset);
                    iday = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);
                    // print( 'day ${selectedDay.day}-${selectedDay.month}-${selectedDay.year} selected');
                    searchpp();

                    //  print('*************************');
                    //  print('$iday is selected');
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              calendarStyle: CalendarStyle(
                todayTextStyle: const TextStyle(color: todayTextColorC),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: borderColorC),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: selectedDayColorC,
                  borderRadius: BorderRadius.circular(10),
                ),
                defaultDecoration: boxDecoC,
                weekendDecoration: boxDecoC,
                rangeStartDecoration: boxDecoC,
                rowDecoration: boxDecoC,
                markerDecoration: boxDecoC,
                holidayDecoration: boxDecoC,
                outsideDecoration: boxDecoC,
                rangeEndDecoration: boxDecoC,
                disabledDecoration: boxDecoC,
                withinRangeDecoration: boxDecoC,
              ),
              // availableCalendarFormats:,
              calendarFormat: CalendarFormat.week,
              availableCalendarFormats: const {
                CalendarFormat.week: 'Week',
              },
              startingDayOfWeek: StartingDayOfWeek.saturday,
              weekendDays: const [DateTime.friday],
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2022, 5,
                  5), //DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
              lastDay: DateTime.utc(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 5)),
          Expanded(
            child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (ctx, index) {
                  if (doctors.isEmpty) {
                    print(doctors.length);

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/isEmpty.png',
                            scale: 3.5,
                          ),
                          const Text(
                            "Hurray! You don't have any appoitments!",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )
                        ],
                      ),
                    );
                  } else {
                    print(doctors.length);

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            color: maincontainer,
                            shadowColor: Colors.black,
                            elevation: 3,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(11, 15, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      ClipOval(
                                        child: doctors[index]['DocPic'] != ""
                                            ? Image.network(
                                                doctors[index]['DocPic'],
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                Icons.person,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                color: Colors.grey.shade400,
                                              ),
                                      ),
                                      SizedBox(width: w * 0.02),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doctors[index]['DoctorsName']
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: txtcolor,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(height: h * 0.01),
                                            const Text(
                                              'cardiologue',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      224, 255, 255, 255)),
                                            )
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<int>(
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            onTap: () {
                                              invoice(
                                                  doctors[index]['PatientName'],
                                                  email.toString(),
                                                  0656598965,
                                                  doctors[index]['DoctorsName']
                                                      .toString(),
                                                  readDateForTicket(
                                                      doctors[index]['date']));
                                            },
                                            value: 1,
                                            child: Text("ticket"),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {
                                              if (doctors[index]
                                                      ['Ordonnance'] ==
                                                  null) {
                                                customSnackBar(
                                                    'Ordonnance hasnt been uploaded yet',
                                                    Colors.red.shade700,
                                                    icon: Icons.info_outline);
                                              } else {
                                                ordonnance(
                                                    doctors[index]
                                                            ['DoctorsName']
                                                        .toString(),
                                                    doctors[index]
                                                        ['Ordonnance'],
                                                    readDateForTicket(
                                                        doctors[index]
                                                            ['date']));
                                              }
                                            },
                                            value: 2,
                                            child: Text("ordonnace"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      style: BorderStyle.none,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    color: seccontainer,
                                  ),
                                  //   margin: EdgeInsets.all(10),
                                  height: h * 0.070,
                                  width: w * 0.875,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month,
                                            color: txtcolor,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(
                                            readTimestampDate(
                                                doctors[index]['date']),
                                            style: const TextStyle(
                                                color: txtcolor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.schedule,
                                            color: txtcolor,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(
                                            '${readTimestampTime(doctors[index]['date'])} ',
                                            style: const TextStyle(
                                                color: txtcolor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  ifempty() {
    if (doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/isEmpty.png',
              scale: 3.5,
            ),
            const Text(
              "Hurray! You don't have any appoitments!",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            )
          ],
        ),
      );
    }
  }

  searchpp() async {
    FirebaseFirestore.instance
        .collection('Appointments')
        .where('patientUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('date', isGreaterThan: Timestamp.fromDate(iday))
        .where('date',
            isLessThan: Timestamp.fromDate(iday.add(Duration(days: 1))))
        // .orderBy('date')
        .snapshots()
        .listen((event) {
      setState(() {
        doctors.clear();

        for (var element in event.docs) {
          doctors.add(element.data());
        }
      });
    });
  }
  ////////////////// TIME STAMP TO DATE TIME FOR AFFICHAGE

  String readTimestampDate(Timestamp timestamp) {
    DateFormat format = DateFormat.yMMMEd();
    return format.format(DateTime.parse(timestamp.toDate().toString()));
  }

  String readTimestampTime(Timestamp timestamp) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(DateTime.parse(timestamp.toDate().toString())) +
        ' - ' +
        format.format(DateTime.parse(
            timestamp.toDate().add(const Duration(hours: 1)).toString()));
  }

/////////////////////////////////////////////////////////////////// GET doctors for ur appointementS
  CollectionReference doctorsref =
      FirebaseFirestore.instance.collection('Appointments');

  getPApp() async {
    doctorsref
        .where('patientUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .orderBy('date')
        .snapshots()
        .listen((event) {
      setState(() {
        doctors.clear();

        for (var element in event.docs) {
          doctors.add(element.data());
        }
      });
    });
  }

  String readDateForTicket(Timestamp timestamp) {
    DateFormat format = DateFormat.yMMMMEEEEd();
    return format.format(DateTime.parse(
            timestamp.toDate().add(DateTime.now().timeZoneOffset).toString())) +
        '\n' +
        readTimestampTime(doctors[index]['date']);
  }

  SnackBar customSnackBar(String customText, Color color, {IconData? icon}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    SnackBar snackBar = SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 4,
          ),
          Text(
            customText + ' ',
            style: TextStyle(fontSize: 17),
          ),
          Icon(
            icon,
            color: Colors.white,
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return snackBar;
  }
}

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:cote_pat/Page/SplashScreen.dart';

import '../Widgets/doctorcard.dart';
import '../profile_page.dart';
import 'Header_widget.dart';
import 'biotablelist.dart';
import 'calendar.dart';
import 'const.dart';
import 'invoice_pdf/pdf_invoice_api.dart';
import 'time_buttons.dart';


DateFormat format = DateFormat('dd - MM - yyyy hh:mm');
String? adress;
String? f, l, u, u2, s, p, e, aa;

class DoctorPage extends StatelessWidget {
  const DoctorPage(
      {Key? key,
      required this.first,
      required this.last,
      required this.uid,
      required this.url,
      required this.spec,
      required this.phone,
      required this.email,
      required this.about})
      : super(key: key);
  final String first;
  final String last;
  final String uid;
  final String url;
  final String spec;
  final String phone;
  final String email;
  final String about;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    const bcgcolor = Color.fromARGB(237, 1, 22, 70);
    const txtcolor = Colors.black;
    f = first;
    l = last;
    u = uid;
    u2 = url;
    s = spec;
    p = phone;
    e = email;
    aa = about;

    FirebaseFirestore.instance
        .collection("Docuser")
        .where("owner", isEqualTo: u)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        adress = element.data()["wilaya"] +
            element.data()["street"] +
            " " +
            "N° " +
            element.data()["house_number"];
      });
    });
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ]),
          ),
        ),
        backgroundColor: bcgcolor,
        leading: const BackButton(color: Colors.black),
        titleSpacing: -15,
       
        elevation: 0,
      ),
      body: BodyBio(
        h: h,
        w: w,
      ),
    );
  }
}

int itim = 77;
DateTime iday = DateTime.now(); // the day selected from the callendar
bool isMAC = true; // make an appointment button

class BodyBio extends StatefulWidget {
  const BodyBio({
    Key? key,
    required this.h,
    required this.w,
  }) : super(key: key);

  final double h;
  final double w;

  @override
  State<BodyBio> createState() => _BodyBioState();
}

int timeLeftvf = 0;

class _BodyBioState extends State<BodyBio> with TickerProviderStateMixin {
  @override
  void initState() {
    //////////
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Stack(children: [
          SizedBox(
            height: widget.h * 0.15,
            child: HeaderWidget(widget.h * 0.15, false, Icons.house_rounded),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 5, color: Colors.white),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(5, 5)),
                    ]),
                child: ClipOval(
                  child: u2 != ""
                      ? Image.network(
                          u2!,
                          width: MediaQuery.of(context).size.width * 0.23,
                          height: MediaQuery.of(context).size.height * 0.13,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: h * 0.13,
                          color: Colors.grey.shade400,
                        ),
                ),
              ),
              SizedBox(
                height: widget.h * 0.01,
              ),
              Text(
                "${f}",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ]),
          )
        ]),
        const Divider(
          endIndent: 70,
          indent: 70,
          thickness: 4,
        ),
        //
        TabBar(
            onTap: (value) {
              itim = 77;
              controller.unselectAll();
            },
            labelColor: labelColorTab,
            unselectedLabelColor: unselectedLabelColorTab,
            controller: _tabController,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: indicatorColorTab,
            tabs: const [
              Tab(
                text: "Schuedle",
              ),
              Tab(text: "Biography")
            ]),

        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 8.6109),
          width: double.maxFinite,
          height: h * 0.5,
          child: TabBarView(controller: _tabController, children: [
            Column(
              children: [
                Container(
                  child: const Calendar(),
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                ),
                SizedBox(
                  height: widget.h * 0.03,
                ),
                const TimeButtons(),
                SizedBox(
                  height: widget.h * 0.055,
                ),
                Container(
                  height: widget.h * 0.05,
                  width: widget.w * 0.60,
                  decoration: BoxDecoration(
                    //  color:Color.fromARGB(255, 51, 139, 255) ,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //color: Color.fromARGB(255, 51, 139, 255),
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent.withOpacity(0.5)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(makeAppColor),
                        // overlayColor:MaterialStateProperty.all<Color>(Colors.grey  ),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('example.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          if (isMAC == true) {
                            try {
                              if (itim == 77 ||
                                  controller.disabledIndexes.contains(itim)) {
                                throw Exception;
                              } else if (dateToUpload.isBefore(
                                  DateTime.now().add(Duration(hours: 1)))) {
                                customSnackBar(
                                    'Cant select a past time', Colors.red,
                                    icon: Icons.info_outline);
                              } else {
                                oneADay();
                                isMAC = false;
                              }
                              //print('You have selected this $itim button \nYou have selected this $iday day');

                              // ScaffoldMessenger.of(context)
                              //     .removeCurrentSnackBar();
                            } catch (e) {
                              customSnackBar('Please select a day and a time',
                                  Colors.red.shade700,
                                  icon: Icons.info_outline);
                            }
                          } else {
                            customSnackBar('Please dont spam!', Colors.red);
                          }
                        }
                      } on SocketException catch (_) {
                        print('no cennecetion');
                        customSnackBar('There is no connection!', Colors.red,
                            icon: Icons.warning_amber);
                      }
                    },
                    child: const Text(
                      "Make An Appointement",
                      //style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SingleChildScrollView(
              child: BioTableList(),
            )
          ]),
        ),
      ],
    );
  }

  oneADay() async {
    bool f = false;
    await FirebaseFirestore.instance
        .collection('Patuser')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ClickDoc')
        .doc(u)
        .get()
        .then((value) {
      f = value['onceADay'];

      if (f == false) {
        _showMaterialDialog();
        disableInCase();
      } else {
        // timerleft();
        d = Timestamp.fromDate(DateTime.now()).seconds;
        _onDejaRdv(
            timeleft - d + 30); // 30 delay brk bah maysrach error kon tbugi
        // SnackBar snackBar = SnackBar(
        //   backgroundColor: const Color.fromARGB(183, 203, 18, 18),
        //   content: TextWithCountdown(
        //       text: 'Time left to click', countValue: timeleft - d+15),
        //   duration: const Duration(seconds: 3),
        //   behavior: SnackBarBehavior.floating,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    isMAC = true;
  }

  CollectionReference doctorsRef =
      FirebaseFirestore.instance.collection('Docuser');

  disableInCase() async {
    List<int> timeSlotIndex = [];

    var resposne = await doctorsRef
        .doc(u) //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .get();
    timeSlotIndex = resposne['timeindex'].cast<int>();

    timeSlotIndex[itim] = itim;
    await doctorsRef
        .doc(u) //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .set({'timeindex': timeSlotIndex});
  }

  enableAfterCase() async {
    List<int> timeSlotIndex = [];

    var resposne = await doctorsRef
        .doc(u) //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .get();
    timeSlotIndex = resposne['timeindex'].cast<int>();

    timeSlotIndex[itim] = 77;
    itim = 77;

    await doctorsRef
        .doc(u) //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .set({'timeindex': timeSlotIndex});
  }

  var d = Timestamp.fromDate(DateTime.now()).seconds;
  void _showMaterialDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Center(child: Text('Are You Sure ?')),
            content: SizedBox(
              height: widget.h * 0.3, //248
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: Icon(Icons.person_outline),
                    title: Text('$f $l'),
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: Icon(Icons.category),
                    title: Text('$s'),
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: const Icon(Icons.calendar_month),
                    title: Text(dateConfrimBox(
                        DateTime.now().withTime(timeSlotToDateTime()))),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (itim != 77) {
                      enableAfterCase();
                    } else {
                      customSnackBar('WARNING : DONT SPAM !!! ', Colors.red,
                          icon: Icons.warning_amber);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('Close')),
              TextButton(
                onPressed: () async {
                  await makeAnAppointment();
                  DateFormat format = DateFormat.yMMMMEEEEd();
                  invoice(
                      firstname! + ' ' + lastname!,
                      email.toString(),
                      0656598965,
                      '$f',
                      dateConfrimBox(
                          DateTime.now().withTime(timeSlotToDateTime())));
                  customSnackBar('Appointment succeeded ',
                      Color.fromARGB(255, 88, 184, 115),
                      icon: Icons.check_circle_outline);
                  Navigator.pop(context);
                },
                child: const Text('Confrim'),
              )
            ],
          );
        });
  }

  makeAnAppointment() async {
    DocumentReference appoinRef =
        FirebaseFirestore.instance.collection('Appointments').doc();
    DocumentReference dmyRef = FirebaseFirestore.instance
        .collection('Docuser')
        .doc(u) //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString());
    DocumentReference clicDocRef = FirebaseFirestore.instance
        .collection('Patuser')
        .doc(FirebaseAuth.instance.currentUser!.uid) //the user uid
        .collection('ClickDoc')
        .doc(u); //the doctor clicked uid
    List<int> timeSlotIndex = [];

    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        var snp = await transaction.get(dmyRef);
        // var tsnp = await transaction.get(dmyRef);
        // var fsnp = await transaction.get(appoinRef);
        //var hsnp = await transaction.get(clicDocRef);

        timeSlotIndex = snp['timeindex'].cast<int>();
        timeSlotIndex[itim] = itim;
        transaction.update(dmyRef, {'timeindex': timeSlotIndex});
        transaction.set(appoinRef, {
          'DoctorsName': '$f',
          'PatientName': '$firstname  $lastname',
          'date': Timestamp.fromDate(dateToUpload.add(DateTime.now()
              .timeZoneOffset)), //  DateTime.now().timeZoneOffset kinda solve error of timezone
          'doctorUID': u,
          'patientUID': FirebaseAuth.instance.currentUser!.uid,
          'DocPic': u2, 
          'PatPic': Urldownload,
        });
        itim = 77;
        transaction.update(clicDocRef, {
          'onceADay': true,
          'timeleft': t - 3600
        }); // 3600 = 1h ta3 firebase timezone

        timeleft = t - 3600;
        timeLeftvf = timeleft - d;
      },
    );

    Timer(Duration(seconds: timeLeftvf), () async {
      await FirebaseFirestore.instance
          .collection('Patuser')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('ClickDoc')
          .doc(u) //the doctor clicked uid
          .update({'onceADay': false, 'timeleft': 0});
    });
  }

  _onDejaRdv(int time) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Center(child: Text('')),
          content: SizedBox(
            height: widget.h * 0.28, //248
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'You do already have an  appointment with this doctor \nTime Left to Click\n'),
                CountDownInText(
                    text: 'To make another appointment you must wait',
                    countValue: time), //timeleft - d
                const Text('\nOr you can cancel it and make another one'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
          ],
        );
      },
    );
  }

  // onceAday() async {
  //   await FirebaseFirestore.instance
  //       .collection('Patuser')
  //       .doc('43vju27PaOZptGuNQvDC') //the doctor clicked uid
  //       .collection('ClickDoc')
  //       .doc(u)
  //       .update({'onceADay': true, 'timeleft': t - d});
  //   print(t - d);
  //   print('***************************1');

  //   await FirebaseFirestore.instance
  //       .collection('Patuser')
  //       .doc('43vju27PaOZptGuNQvDC')
  //       .collection('ClickDoc')
  //       .doc('yzreO3TrzblximKsxdz2')
  //       .get()
  //       .then(
  //     (value) {
  //       timeleft = value['timeleft'];
  //     },
  //   );
  //   print(timeleft);
  //   print("=*=*=*=*=*=*=**==*=");

  //   Timer(Duration(seconds: timeleft), () async {
  //     await FirebaseFirestore.instance
  //         .collection('Patuser')
  //         .doc('43vju27PaOZptGuNQvDC') //the doctor clicked uid
  //         .collection('ClickDoc')
  //         .doc('yzreO3TrzblximKsxdz2')
  //         .update({'onceADay': false, 'timeleft': 0});
  //   });
  //   Timer.periodic(
  //     const Duration(seconds: 1),
  //     (timer) {
  //       if (timeleft > 0) {
  //         timeleft--;
  //       } else {
  //         timer.cancel();
  //         // timeleft = 0;
  //       }
  //     },
  //   );
  // }

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

String dateConfrimBox(DateTime timestamp) {
  DateFormat format = DateFormat.yMMMMEEEEd();
  DateFormat fodrmat = DateFormat('HH:mm');

  return format.format(timestamp) +
      '\n' +
      fodrmat.format(timestamp) +
      ' - ' +
      fodrmat.format(timestamp.add(const Duration(hours: 1)));
}

class CountDownInText extends StatefulWidget {
  final String text;
  final int countValue;

  const CountDownInText({
    Key? key,
    required this.text,
    required this.countValue,
  }) : super(key: key);

  @override
  _CountDownInText createState() => _CountDownInText();
}

class _CountDownInText extends State<CountDownInText> {
  late int count = widget.countValue;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), _timer);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          intToTimeLeft(count),
          style: const TextStyle(fontSize: 12.5),
        ),
      ],
    );
  }

  void _timer(Timer timer) {
    setState(() {
      count -= 1;
    });
    if (count <= 0) {
      timer.cancel();
    }
  }

  String intToTimeLeft(int value) {
    int seconds = value % 60;
    int minutes = value % 3600 ~/ 60;
    int hours = value % 86400 ~/ 3600;
    int days = value ~/ 86400;
    return "$days days,$hours hours,$minutes minutes,$seconds seconds";
  }
}

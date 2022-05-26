import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/doctors.dart';
import 'const.dart';
import 'time_buttons.dart';
import 'calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'Header_widget.dart';
import 'biotablelist.dart';
import 'invoice_pdf/pdf_invoice_api.dart';

DateFormat format = DateFormat('dd - MM - yyyy hh:mm');
int itim = 77;
DateTime iday = DateTime.now(); // the day selected from the callendar
bool isMAC = true; // make an appointment button
int timeleft = 0;
int timeLeftvf = 0;

class DoctorPage extends StatelessWidget {
  Doctor doc;

  DoctorPage({required this.doc});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BodyBio(
        h: h,
        w: w,
      ),
    );
  }
}


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



class _BodyBioState extends State<BodyBio> with TickerProviderStateMixin {
// ignore: recursive_getters
get doc => doc;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
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
                  child: Icon(
                    Icons.person,
                    size: widget.h * 0.13,
                    color: Colors.grey.shade400,
                  ),
                ),
                SizedBox(
                  height: widget.h * 0.01,
                ),
                const Text(
                  "Doctor_Name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  text: "Schdule",
                ),
                Tab(text: "Biography")
              ]),

          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 8.6109),
            width: double.maxFinite,
            height: h * 0.55,
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
      ),
    );
  }

  timerleft() async {
    await FirebaseFirestore.instance
        .collection('Patuser')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ClickDoc')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
        .get()
        .then(
      (value) {
        timeleft = value['timeleft'];
      },
    );
  }

  oneADay() async {
    bool f = false;
    await FirebaseFirestore.instance
        .collection('Patuser')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ClickDoc')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
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
      }
    });
    isMAC = true;
  }

  CollectionReference doctorsRef =
      FirebaseFirestore.instance.collection('Docuser');

  disableInCase() async {
    List<int> timeSlotIndex = [];

    var resposne = await doctorsRef
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .get();
    timeSlotIndex = resposne['timeindex'].cast<int>();

    timeSlotIndex[itim] = itim;
    await doctorsRef
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .set({'timeindex': timeSlotIndex});
  }

  enableAfterCase() async {
    List<int> timeSlotIndex = [];

    var resposne = await doctorsRef
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .get();
    timeSlotIndex = resposne['timeindex'].cast<int>();

    timeSlotIndex[itim] = 77;
    itim = 77;

    await doctorsRef
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .set({'timeindex': timeSlotIndex});
  }

  makeAnAppointment() async {
    var notref = FirebaseFirestore.instance.collection('Appointments');
    var ref = FirebaseFirestore.instance.collection('Docuser');

    List<int> timeSlotIndex = [];

    var resposne = await ref
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .get();
    timeSlotIndex = resposne['timeindex'].cast<int>();

    timeSlotIndex[itim] = itim;

    await ref
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .set({'timeindex': timeSlotIndex});

    await notref.add({
      'DoctorsName': 'dr Yassine Zelmati',
      'PatientName': 'Ahmed',
      'date': Timestamp.fromDate(dateToUpload.add(DateTime.now()
          .timeZoneOffset)), //  DateTime.now().timeZoneOffset kinda solve error of timezone
      'doctorUID': 'g9VUZSPoX6YyWqjzhnZ0oSd3pBo2',
      'patientUID': FirebaseAuth.instance.currentUser!.uid,
    });
    itim = 77;

    await FirebaseFirestore.instance
        .collection('Patuser')
        .doc(FirebaseAuth.instance.currentUser!.uid) //the doctor clicked uid
        .collection('ClickDoc')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
        .update({
      'onceADay': true,
      'timeleft': t - 3600
    }); //time left to click the button after ur rdv passed

    await FirebaseFirestore.instance
        .collection('Patuser')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ClickDoc')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
        .get()
        .then(
      (value) {
        timeleft = value['timeleft'];
        timeLeftvf = timeleft - d;
      },
    );

    Timer(Duration(seconds: timeLeftvf), () async {
      await FirebaseFirestore.instance
          .collection('Patuser')
          .doc(FirebaseAuth.instance.currentUser!.uid) //the doctor clicked uid
          .collection('ClickDoc')
          .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
          .update({'onceADay': false, 'timeleft': 0});
    });
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
              height: widget.h * 0.28, //248
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    horizontalTitleGap: 2,
                    leading: Icon(Icons.person_outline),
                    title: Text('Doctor Zelmati Yassine'),
                  ),
                  const Divider(thickness: 2),
                  const ListTile(
                    horizontalTitleGap: 2,
                    leading: Icon(Icons.category),
                    title: Text('Cardiologue'),
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
                  await makeddddAppointment();
                  DateFormat format = DateFormat.yMMMMEEEEd();
                  invoice(
                      'naaaaa',
                      'patientEmail',
                      0656598965,
                      ['DoctorsName'].toString(),
                      'mazl f collection email',
                      448787,
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

  makeddddAppointment() async {
    DocumentReference appoinRef =
        FirebaseFirestore.instance.collection('Appointments').doc();
    DocumentReference dmyRef = FirebaseFirestore.instance
        .collection('Docuser')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString());
    DocumentReference clicDocRef = FirebaseFirestore.instance
        .collection('Patuser')
        .doc(FirebaseAuth.instance.currentUser!.uid) //the user uid
        .collection('ClickDoc')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2'); //the doctor clicked uid
    List<int> timeSlotIndex = [];

    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        var snp = await transaction.get(dmyRef);

        timeSlotIndex = snp['timeindex'].cast<int>();
        timeSlotIndex[itim] = itim;
        transaction.update(dmyRef, {'timeindex': timeSlotIndex});
        transaction.set(appoinRef, {
          'DoctorsName': 'dr Yassine Zelmati',
          'PatientName': 'Ahmed',
          'date': Timestamp.fromDate(dateToUpload.add(DateTime.now()
              .timeZoneOffset)), //  DateTime.now().timeZoneOffset kinda solve error of timezone
          'doctorUID': 'g9VUZSPoX6YyWqjzhnZ0oSd3pBo2',
          'patientUID': FirebaseAuth
              .instance.currentUser!.uid, // lzm nizdo both phones and emails
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
          .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
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
          title: const Center(child: Text('???????')),
          content: SizedBox(
            height: widget.h * 0.28, //248
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'You do already have an  appointment with this doctor \nTime Left to Click\n'),
                CountDownInText(
                    text: 'Time left to click',
                    countValue: time), //timeleft - d
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
  // final VoidCallback? onCountDown;

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

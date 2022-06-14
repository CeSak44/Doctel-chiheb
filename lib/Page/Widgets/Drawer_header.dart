import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/Page/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class drawer_header extends StatefulWidget {
  const drawer_header({Key? key}) : super(key: key);

  @override
  State<drawer_header> createState() => _drawer_headerState();
}

Future getaPic() async {
  await FirebaseFirestore.instance
      .collection("Docuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      Urldownload = element.data()["picture"];
    });
  });
}
Future getData() async {
  await FirebaseFirestore.instance
      .collection("Docuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      firstname = element.data()["firstname"];
    });
  });
  return firstname;
}

Future getDataLast() async {
  await FirebaseFirestore.instance
      .collection("Docuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      lastname = element.data()["lastname"];
    });
  });
}

Future getDataEmail() async {
  await FirebaseFirestore.instance
      .collection("Docuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      email = element.data()["email"];
    });
  });
}
class _drawer_headerState extends State<drawer_header>
    with SingleTickerProviderStateMixin {
  void initState() {
    FirebaseFirestore.instance
        .collection("Patuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
          firstname = element.data()["firstname"];
          print("about :${element.data()["firstname"]}");
        });
      });
    });
    FirebaseFirestore.instance
        .collection("Patuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
          email = element.data()["email"];
          print("about :${element.data()["email"]}");
        });
      });
    });
    FirebaseFirestore.instance
        .collection("Patuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
          lastname = element.data()["lastname"];
          print("about :${element.data()["lastname"]}");
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Padding:
    // EdgeInsets.only(
    //   top: 24 + MediaQuery.of(context).padding.top,
    //   bottom: 24,
    // );
    return Container(
        color: Color.fromRGBO(57, 126, 245, 20),
        width: double.infinity,
        height: 250,
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
         ),
        child: Column(
          children: [
          // CircleAvatar(
          //   radius: 52,
          //   backgroundImage :Urldownload != null
          //                         ? Image.network(
          //                             Urldownload!,
          //                             width: MediaQuery.of(context).size.width *
          //                                 0.35,
          //                             height:
          //                                 MediaQuery.of(context).size.height *
          //                                     0.2,
          //                             fit: BoxFit.cover,
          //                           )
          //                         : Icon(
          //                             Icons.person,
          //                             size: h * 0.13,
          //                             color: Colors.grey.shade400,
          //                           ),
          // ),
                       ClipOval(
                              child: Urldownload != ""
                                  ? Image.network(
                                      Urldownload!,
                                      width: 100,
                                      height:
                                          100,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: MediaQuery.of(context).size.height * 0.13,
                                      color: Colors.grey.shade400,
                                  ),
                                  ),
           Text("${firstname} ${lastname}",style: TextStyle(
             fontSize: 28 , color: Colors.white
           ),
           ),                     
              Text("${email}",style: TextStyle(
             fontSize: 16 , color: Colors.white
           ),
           )  ,

        ]));
  }
}

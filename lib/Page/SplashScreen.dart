
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../homepage.dart';
import 'Login_page.dart';
String? firstname, lastname, specialite, phone, email,about;
String? wilayat, stret, number;
String?  Urldownload;
String? lname, fname, ph;
List<dynamic> cats = [];

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  
  bool? isLogin;
  bool _isVisible = false;
  var user = FirebaseAuth.instance.currentUser;
  
  _SplashScreenState() {
     Timer(const Duration(milliseconds: 2000), () {
      /////////
      setState(() async {
        if(isLogin==true){  await FirebaseFirestore.instance
              .collection('Specialities')
              .get()
              .then((value) => value.docs.forEach((element) {
                    categories.add(element);
                  }));
      
    // });
          FirebaseFirestore.instance
        .collection("Patuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        event.docs.forEach((element) {
          Urldownload = element.data()["picture"];
          print("picture :${element.data()["picture"]}");
        });
      });
    });
          await FirebaseFirestore.instance
            .collection("Patuser")
            .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            firstname = element.data()["firstname"];
          });
        });
        //////////
        ///
        ///
        await FirebaseFirestore.instance
      .collection("Patuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      lastname = element.data()["lastname"];
    });
  });
     await FirebaseFirestore.instance
      .collection("Patuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      about = element.data()["about"];
    });
  });
    await FirebaseFirestore.instance
      .collection("Patuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      email = element.data()["email"];
    });
  });
  await FirebaseFirestore.instance
      .collection("Adresses")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      wilayat = element.data()["wilaya"];
    });
  });
  await FirebaseFirestore.instance
      .collection("Adresses")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      stret = element.data()["street"];
    });
  });
  await FirebaseFirestore.instance
      .collection("Adresses")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      number = element.data()["house_number"];
    });
  });
  await FirebaseFirestore.instance
      .collection("Docuser")
      .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      phone = element.data()["phone"];
    });
  });
  
        }
        ///////////
        
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    isLogin == false ? LoginPage() : HomePgae()),
            (route) => false);
      });
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (user == null) {
      isLogin = false;
    } else {
      isLogin = true;
    }
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
        colors: [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).primaryColor
        ],
        begin: const FractionalOffset(0, 0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      )),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: h * 0.37,
              ),
              Container(
                height: h * 0.3,
                width: w * 0.3,
                child: Center(
                  // child: ClipOval(
                  child: Image(
                    image: AssetImage(
                      'img/logosplash.png',
                    ),
                  ),
                  // child: Icon(Icons.android_outlined,size:128),
                  // ),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}

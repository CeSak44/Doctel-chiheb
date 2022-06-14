import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/them_helper.dart';
import '../SplashScreen.dart';

class Modifier extends StatefulWidget {
  const Modifier({Key? key}) : super(key: key);

  @override
  State<Modifier> createState() => _ModifierState();
}

class _ModifierState extends State<Modifier> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future uploadFile() async {
    final path = 'files/images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    //FirebaseStorage
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    // The link to the profil image ///////////////////////////////////////////////
    final urldownload = await snapshot.ref.getDownloadURL();
    Urldownload = urldownload;
    //////////////////////////////////////---------------------URL --------------------------////////////////////////////////////
    print('Download Link of the profil image: $urldownload');
  }

  Future getaPic() async {
    await FirebaseFirestore.instance
        .collection("Patuser")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Urldownload = element.data()["picture"];
      });
    });
  }

  @override
  void initState() {
    // FirebaseFirestore.instance
    //     .collection("Patuser")
    //     .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .snapshots()
    //     .listen((event) {
    //   setState(() {
    //     event.docs.forEach((element) {
    //       phone = element.data()["phone"];
    //       print("about :${element.data()["phone"]}");
    //     });
    //   });
    // });
    // FirebaseFirestore.instance
    //     .collection("Patuser")
    //     .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .snapshots()
    //     .listen((event) {
    //   setState(() {
    //     event.docs.forEach((element) {
    //       about = element.data()["about"];
    //       print("about :${element.data()["about"]}");
    //     });
    //   });
    // });
    // FirebaseFirestore.instance
    //     .collection("Adresses")
    //     .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .snapshots()
    //     .listen((event) {
    //   setState(() {
    //     event.docs.forEach((element) {
    //       stret = element.data()["street"];
    //       print("about :${element.data()["street"]}");
    //     });
    //   });
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

    // getData();
    // getDataLast();
    // getabout();
    // getDataPhone();
    // getDataStreet();
//     getDataEmail();
//     getDataHousenum();

    super.initState();
  }

  // var firstname, lastname, password, phone, about, stret;
  TextEditingController lname =new TextEditingController();
  TextEditingController fname =new TextEditingController();
  TextEditingController phne =new TextEditingController();
   final _formKey = GlobalKey<FormState>();
  @override
 
  String lastnamme = "p";
  String firstnamme = "tre";
  var ph;
  CollectionReference userref =
      FirebaseFirestore.instance.collection("Patuser");
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Form(
      child: Column(
        key: _formKey,
        children: [
          Container(
            child: TextFormField(
              onSaved: (val) {
                   firstnamme = val!;
               },
              decoration: ThemHelper()
                  .textInputDecoration('First Name', 'Enter your first name'),
            ),
            decoration: ThemHelper().inputBoxDecorationShaddow(),
          ),
          SizedBox(
            height: h * 0.03,
          ),
          Container(
            child: TextFormField(
              onSaved: (val) {
                  lastnamme = val!;
              },
              decoration: ThemHelper()
                  .textInputDecoration('Last Name', 'Enter your last name'),
            ),
            decoration: ThemHelper().inputBoxDecorationShaddow(),
          ),
          SizedBox(
            height: h * 0.03,
          ),
          Container(
            child: TextFormField(
               onSaved: (val) {
                 ph = val;
                 },
        
              keyboardType: TextInputType.phone,
              decoration:
                  ThemHelper().textInputDecoration('phone', 'Enter your phone'),
            ),
            decoration: ThemHelper().inputBoxDecorationShaddow(),
          ),
           SizedBox(
            height: h * 0.03,
          ),
          Container(
            decoration: ThemHelper().buttonBoxDecoration(context),
            child: ElevatedButton(
                style: ThemHelper().buttonStyle(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Text(
                    "confirmer".toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () async {
                  await   uploadFile();
                //  _formKey.currentState?.save();
                    await userref
                       .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                   "firstname": firstname,
                  "lastname": lastname,
                   // "phone":phone,
                   "picture": Urldownload,
                   });
                  // await userref
                  //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //     .update({
                  //   "lastname": lname.text,
                  //   "firstname": fname.text,
                  //   "phone": phne,
                  // });
                 
                }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
        ],
      ),
    );
  }
}


//https://console.firebase.google.com/u/0/project/doctel-65452/firestore/data/~2FAdresses~2F4qmgnxbKzjYwQS2TOj4ccalqgvs1

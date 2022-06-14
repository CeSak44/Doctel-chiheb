import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Page/profile_page.dart';
import 'package:flutter_application_1/Page/showLoading.dart';
import 'package:flutter_application_1/homepage.dart';

class aboutPage extends StatefulWidget {
  aboutPage({Key? key}) : super(key: key);

  @override
  State<aboutPage> createState() => _aboutState();
}

class _aboutState extends State<aboutPage> {
  @override
  String? about;
  final _formKey = GlobalKey<FormState>();
  CollectionReference userref =
      FirebaseFirestore.instance.collection("Docuser");
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: AlertDialog(
            title: Text("Edit your about:"),
            content: TextFormField(
              onSaved: (val) {
                about = val;
              },
              validator: (val) {
                 int? x = val?.length;
                 if (x! > 300) {
                                return "the bio cant be larger than 250 letter";
                              }
                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              
              decoration: InputDecoration(hintText: "Enter your text here"),
            ),
            actions: [
              TextButton(
                onPressed:(){
                  Navigator.of(context).pop();
                  }
                ,
               child: Text("CANCEL")),
              TextButton(
                  onPressed: () async {
                    _formKey.currentState?.save();
                    print(about);
                                        showLoading(context);
                    await userref
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"about": about});
                     FirebaseFirestore.instance
                        .collection("Docuser")
                        .where("owner",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots()
                        .listen((event) {
                      setState(() {
                        event.docs.forEach((element) {
                          about = element.data()["about"];
                          print("about :${element.data()["about"]}");
                        });
                      });
                    });
                    //     .get()
                    //     .then((value) {
                    //   value.docs.forEach((element) {
                    //     about = element.data()["about"];
                    //   });
                    // });
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePgae()));
                  },
                  child: Text("SUBMIT"))
            ],
          ),
        ));
  }
}

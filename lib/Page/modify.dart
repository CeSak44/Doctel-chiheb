import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../common/them_helper.dart';
import 'SplashScreen.dart';
import 'showLoading.dart';

TextEditingController crc1 = TextEditingController();
TextEditingController crc2 = TextEditingController();
TextEditingController crc3 = TextEditingController();
TextEditingController crc4 = TextEditingController();
TextEditingController crc5 = TextEditingController();
TextEditingController crc6 = TextEditingController();


class Modifierpr extends StatefulWidget {
  const Modifierpr({Key? key}) : super(key: key);

  @override
  State<Modifierpr> createState() => _ModifierprState();
}

showLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("please wait"),
          content: Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              )),
        );
      });
}

final _formKey = GlobalKey<FormState>();
final _formKey1 = GlobalKey<FormState>();

final _formKey2 = GlobalKey<FormState>();

String? firstname01;
String? lastnamme;

class _ModifierprState extends State<Modifierpr> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future uploadFile() async {
    try {
      var path = 'files/images/${pickedFile?.name}';
      var file = File(pickedFile!.path!);
      //FirebaseStorage
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});
      // The link to the profil image ///////////////////////////////////////////////
      final urldownload = await snapshot.ref.getDownloadURL();
      Urldownload = urldownload;
      //////////////////////////////////////---------------------URL --------------------------////////////////////////////////////
      print('Download Link of the profil image: $urldownload');
    } catch (e) {
      print(e);
    }
  }

  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
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

  //  Future getData() async {
  //    await FirebaseFirestore.instance
  //        .collection("Patuser")
  //        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //        .get()
  //        .then((value) {
  //      value.docs.forEach((element) {
  //        firstname = element.data()["firstname"];
  //      });
  //    });
  //  }

  @override
  void initState() {
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

    // FirebaseFirestore.instance
    //     .collection("Patuser")
    //     .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .snapshots()
    //     .listen((event) {
    //   setState(() {
    //     event.docs.forEach((element) {
    //       firstname = element.data()["firstname"];
    //       print("firstname :${element.data()["firstname"]}");
    //       // lastname = element.data()["lastname"];
    //       // print("lastname :${element.data()["lastname"]}");
    //       // phone = element.data()["phone"];
    //       // print("phone :${element.data()["phone"]}");
    //     });
    //   });
    // });
    // getData();
    // getDataLast();
    // getabout();
    // getDataPhone();
    // getDataStreet();w
//     getDataEmail();
//     getDataHousenum();

    super.initState();
  }

  var phonne;
  @override
  final CollectionReference userref =
      FirebaseFirestore.instance.collection("Patuser");
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor: Colors.blue,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text("Edit Profil"),
        titleSpacing: -15,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(56, 124, 240, 100),
                                    width: 5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: ClipOval(
                                child: pickedFile != null
                                    ? Image.file(
                                        File(pickedFile!.path!),
                                        width:
                                           150,
                                        height:
                                           150,
                                        fit: BoxFit.cover,
                                      )
                                   : Urldownload !="" ? 
                                    Image.network(
                                        Urldownload!,
                                        width:
                                           150,
                                        height:
                                           150,
                                        fit: BoxFit.cover,
                                      ) : Icon(
                                    Icons.person,
                                    size: h * 0.20,
                                    color: Colors.grey.shade400,
                                  ),
                                // : Image.network(
                                //     Urldownload!,
                                //     width:
                                //         MediaQuery.of(context).size.width *
                                //             0.35,
                                //     height:
                                //         MediaQuery.of(context).size.height *
                                //             0.2,
                                //     fit: BoxFit.cover,
                                //   ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: ElevatedButton.icon(
                                onPressed: selectfile,
                                icon: Icon(
                                  Icons.add_a_photo_sharp,
                                  size: h * 0.025,
                                ),
                                label: Text('Pic IMAGE'.toUpperCase())),
                          ),
                          SizedBox(
                            width: w * 0.1,
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                showLoading(context);
                                await uploadFile();
                                print("===============");
                                await userref
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update(
                                  {
                                    "picture": Urldownload,
                                  },
                                );

                                Navigator.of(context).pop();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ThemHelper().alartDialog(
                                        "Alert:",
                                        "You have updated your profile picture successfully!",
                                        context);
                                  },
                                );
                              },
                              child: Text("Confirm"),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      //Modifier(),
                      ////////////////////////
                      Form(
                        child: Column(
                          key: _formKey,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: w * 0.8,
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    controller: crc1,
                                  
                                   
                                    decoration: ThemHelper()
                                        .textInputDecoration('First Name',
                                            'Enter your first name'),
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (crc1.text == "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Last name:",
                                                "Select your firstname please!.",
                                                context);
                                          },
                                        );
                                      } else {
                                        showLoading(context);
                                        await FirebaseFirestore.instance
                                            .collection("Patuser")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .update({
                                          "firstname": crc1.text,
                                        });
                                        print(
                                            "+++++++++++++++++++++++++++++++++++++");
                                        print(crc1.text);
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Alert:",
                                                "You have updated your first name successfully!",
                                                context);
                                          },
                                        );
                                      }
                                    },
                                    child: Text("Edit "),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: w * 0.8,
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    controller: crc2,
                                    decoration: ThemHelper()
                                        .textInputDecoration('last Name',
                                            'Enter your last name'),
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                   if (crc2.text == "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Last name:",
                                                "Enter your lastname.",
                                                context);
                                          },
                                        );
                                      } else {
                                        showLoading(context);
                                        await FirebaseFirestore.instance
                                            .collection("Patuser")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .update({
                                          "lastname": crc2.text,
                                        });
                                        print(
                                            "+++++++++++++++++++++++++++++++++++++");
                                        print(crc2.text);
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Alert:",
                                                "You have updated your last name successfully!",
                                                context);
                                          },
                                        );
                                      }
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                
                                
                              ],
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                             Row(
                              children: [
                                Container(
                                  width: w * 0.8,
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    controller: crc3,
                                    decoration: ThemHelper()
                                        .textInputDecoration('Wilaya',
                                            'Enter your wilaya'),
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                   if (crc3.text == "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Adress:",
                                                "Enter your wilaya please.",
                                                context);
                                          },
                                        );
                                      } else {
                                        showLoading(context);
                                        await FirebaseFirestore.instance
                                            .collection("Patuser")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .update({
                                          "wilaya": crc3.text,
                                        });
                                        print(
                                            "+++++++++++++++++++++++++++++++++++++");
                                        print(crc3.text);
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Alert:",
                                                "You have updated your wilaya successfully!",
                                                context);
                                          },
                                        );
                                      }
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                
                                
                              ],
                            ),
                             SizedBox(
                              height: h * 0.03,
                            ),
                             Row(
                              children: [
                                Container(
                                  width: w * 0.8,
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    controller: crc4,
                                    decoration: ThemHelper()
                                        .textInputDecoration('Street',
                                            'Enter your new street'),
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                   if (crc4.text == "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Adress:",
                                                "Enter your street please.",
                                                context);
                                          },
                                        );
                                      } else {
                                        showLoading(context);
                                        await FirebaseFirestore.instance
                                            .collection("Patuser")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .update({
                                          "wilaya": crc4.text,
                                        });
                                        print(
                                            "+++++++++++++++++++++++++++++++++++++");
                                        print(crc4.text);
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Alert:",
                                                "You have updated your street successfully!",
                                                context);
                                          },
                                        );
                                      }
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                
                                
                              ],
                            ),
                             SizedBox(
                              height: h * 0.03,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: w * 0.8,
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                  controller: crc5,
                                    decoration: ThemHelper()
                                        .textInputDecoration('House number',
                                            'Enter your new house number'),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      print(crc3.text);
                                     if (crc5.text == "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "House number:",
                                                "Enter your house number.",
                                                context);
                                          },
                                        );
                                      } else {
                                        showLoading(context);
                                        await FirebaseFirestore.instance
                                            .collection("Patuser")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .update({
                                          "house_number": crc5.text,
                                        });
                                        print(
                                            "+++++++++++++++++++++++++++++++++++++");
                                        print(crc5.text);
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Alert:",
                                                "You have updated your phone successfuly!",
                                                context);
                                          },
                                        );
                                      }
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // Container(
                            //   decoration:
                            //       ThemHelper().buttonBoxDecoration(context),
                            //   child: ElevatedButton(
                            //       style: ThemHelper().buttonStyle(),
                            //       child: Padding(
                            //         padding: const EdgeInsets.fromLTRB(
                            //             40, 10, 40, 10),
                            //         child: Text(
                            //           "Edit Fname".toUpperCase(),
                            //           style: TextStyle(
                            //             fontSize: 20,
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //       ),
                            //       onPressed: () async {
                            //         if (_formKey.currentState!.validate()) {
                            //           var formdata = _formKey.currentState;
                            //           formdata?.save();
                            //           print(
                            //               "+++++++++++++++++++++++++++++++++++++");
                            //           print(firstname01);
                            //         }
                            //         // if (_formKey.currentState!.validate()) {
                            //         //   _formKey.currentState?.save();
                            //         //   // showLoading(context);
                            //         //   // await FirebaseFirestore.instance
                            //         //   //     .collection("Patuser")
                            //         //   //     .doc(FirebaseAuth
                            //         //   //         .instance.currentUser?.uid)
                            //         //   //     .update({
                            //         //   //   "firstname": firstname01,
                            //         //   // });

                            //         //   print(
                            //         //       "+++++++++++++++++++++++++++++++++++++");
                            //         //   print(firstname01);
                            //         // }
                            //       }),
                            // ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: w * 0.8,
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                  controller: crc6,
                                    decoration: ThemHelper()
                                        .textInputDecoration('Phone Number',
                                            'Enter your phone number'),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      print(crc6.text);
                                     if (crc6.text == "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Phone:",
                                                "Enter your phone number please.",
                                                context);
                                          },
                                        );
                                      } else if (crc6.text.length!=10) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Phone:",
                                                "Phone number must be in 10 digits.",
                                                context);
                                          },
                                        );
                                      }else {
                                        showLoading(context);
                                        await FirebaseFirestore.instance
                                            .collection("Patuser")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .update({
                                          "phone": crc6.text,
                                        });
                                        print(
                                            "+++++++++++++++++++++++++++++++++++++");
                                        print(crc5.text);
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemHelper().alartDialog(
                                                "Alert:",
                                                "You have updated your phone successfuly!",
                                                context);
                                          },
                                        );
                                      }
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                       
                          ],
                        ),
                      ),
                     
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

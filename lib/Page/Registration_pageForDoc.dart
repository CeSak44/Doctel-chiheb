import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../common/them_helper.dart';
import '../homepage.dart';
import 'SplashScreen.dart';
import 'VerifyEmailPage.dart';
import 'Widgets/Header_widget.dart';
import 'profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'showLoading.dart';

class RegistrationPageForDoc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageForDocState();
  }
}

List items = [];
var photo;
File? file;
String? token;
bool isReadmore = false;

class _RegistrationPageForDocState extends State<RegistrationPageForDoc> {
  @override
  void initState() {
    listing();
    super.initState();
  }

  @override
  final _formKey = GlobalKey<FormState>();
  File? pickedImage;

  pickImage(ImageSource imageType) async {
    try {
      photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Widget buildText(String text) {
    final maxlines = isReadmore ? null : 1;
    final overflow = isReadmore ? TextOverflow.visible : TextOverflow.ellipsis;
    return Text(
      text,
      overflow: overflow,
      maxLines: maxlines,
      style: TextStyle(fontSize: 18, color: Colors.grey),
    );
  }

  Widget buildBotton() => TextButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            textStyle: TextStyle(fontSize: 15, color: Colors.grey)),
        child: Text(isReadmore ? "Read Less" : "Read More"),
        onPressed: () {
          setState(() {
            isReadmore = !isReadmore;
          });
        },
      );

  // imagePickerOption() {
  //   var pic;
  //   Get.bottomSheet(
  //     SingleChildScrollView(
  //       child: ClipRRect(
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(10.0),
  //           topRight: Radius.circular(10.0),
  //         ),
  //         child: Container(
  //           color: Colors.white,
  //           height: 250,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 const Text(
  //                   "Choissir Une Image ",
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 ElevatedButton.icon(
  //                   onPressed: () async {
  //                     pic = await pickImage(ImageSource.camera);
  //                   },
  //                   icon: const Icon(Icons.camera),
  //                   label: const Text("CAMERA"),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 ElevatedButton.icon(
  //                   onPressed: () async {
  //                     pic = await pickImage(ImageSource.gallery);
  //                   },
  //                   icon: const Icon(Icons.image),
  //                   label: const Text("GALLERY"),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 ElevatedButton.icon(
  //                   onPressed: () {
  //                     pic = null;
  //                     Get.back();
  //                   },
  //                   icon: const Icon(Icons.close),
  //                   label: const Text("CANCEL"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  bool checkedValue = false;
  bool checkboxValue = false;
  late UserCredential userCredential;
  String? firstname, lastname, email, password, phone, urldownload;
  // List<String> items = [
  //   "cardiologue",
  //   "pédiatre",
  //   "généraliste",
  //   "radiologue",
  //   "physiatre"
  // ];
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

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(DateTime(startDate.year, startDate.month, startDate.day + i));
    }
    return days;
  }

  setDateOfNewDoctor() async {
    getDaysInBeteween(
            DateTime.utc(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            DateTime.utc(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 5))
        .forEach((element) async {
      await FirebaseFirestore.instance
          .collection('Docuser')
          .doc(FirebaseAuth.instance.currentUser?.uid) //the doctor clicked uid
          .collection('day-month-year')
          .doc(element.toString())
          .set({
        'timeindex': [77, 77, 77, 77, 77, 77]
      });
    });
  }

  String? specialite;
  Future signUp() async {
    if (_formKey.currentState!.validate() && specialite != null) {
      var formdata = _formKey.currentState;
      formdata?.save();

      try {
        showLoading(context);
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        token = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance
            .collection("Docuser")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          "token": token,
          "about": "",
          "owner": FirebaseAuth.instance.currentUser?.uid,
          "email": email?.trim(),
          "firstname": firstname?.trim(),
          "lastname": lastname?.trim(),
          "isAccepted": false,
          "phone": phone?.trim(),
          "specialité": specialite,
          "picture": Urldownload == null ? "" : Urldownload,
          "wilaya": "",
          "street": "",
          "house_number": "",
        });
        await uploadFile();

        await FirebaseFirestore.instance
            .collection('Patuser')
            .get()
            .then((value) => value.docs.forEach((element) {
                  FirebaseFirestore.instance
                      .collection('Patuser')
                      .doc(element.id)
                      .collection('ClickDoc')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({'onceADay': false, 'timeleft': 0});
                }));
        setDateOfNewDoctor();

        // await FirebaseFirestore.instance.collection("Docuser").add({
        //   "about":null,
        //    "owner":FirebaseAuth.instance.currentUser?.uid,
        //     "email": email,
        //     "firstname": firstname,
        //     "lastname":lastname,
        //      "isAccepted":false,
        //      "phone":phone,
        //      "specialité":specialite,
        // });

        Navigator.pushReplacementNamed(context, "adress");

        // Navigator.pushReplacementNamed(context, "home");

        //   User? user = FirebaseAuth
        //                 .instance.currentUser;
        //             await user?.sendEmailVerification();
        //             showDialog(
        //                 context: context,
        //                 builder:
        //                     (BuildContext context) {
        //                   return ThemHelper().alartDialog(
        //                       "Email verification:",
        //                       "We have sent a mail to your email to verify it.",
        //                       context);
        //                 },
        //               );
        //                if (userCredential
        //                   .user?.emailVerified ==
        //               true){print(userCredential.user?.emailVerified);
        //               print("==================================");
        //  Navigator.pushReplacementNamed(context, "home");}
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ThemHelper().alartDialog(
                  "Password", "The password provided is too weak.", context);
            },
          );
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ThemHelper().alartDialog("Email",
                  "The account already exists for that email.", context);
            },
          );
          print('The account already exists for that email.');
        } else {
          Navigator.of(context).pop();

          print(e);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ThemHelper()
                  .alartDialog("erreur", e.message.toString(), context);
            },
          );
        }
      }
    }
  }

  listing() async {
    items.clear();
    await FirebaseFirestore.instance
        .collection('Specialities')
        .get()
        .then((value) => value.docs.forEach((element) {
              setState(() {
                items.add(element.data()['spec']);
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    print("================");
    print(items);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: h * 0.22,
              child:
                  HeaderWidget(h * 0.22, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: w * 0.005, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: pickedFile != null
                                      ? Image.file(
                                          File(pickedFile!.path!),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: Colors.grey.shade300,
                                          size: h * 0.14,
                                        ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                  child: IconButton(
                                    onPressed: () async {
                                      selectfile();

                                      print("ffffffffffffff");
                                      if (photo != null) {
                                        print(
                                            "YEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEES");
                                        file = File(photo.path);
                                        //  var nameimage = basename()
                                      } else {
                                        print(
                                            "NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO  OOOOOOO");
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey.shade700,
                                      size: h * 0.045,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                        Text(
                          "Welcome Doctor!".toUpperCase(),
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: h * 0.06,
                        ),
                        // profileImage(),
                        Container(
                          child: TextFormField(
                            onSaved: (val) {
                              firstname = val;
                            },
                            decoration: ThemHelper().textInputDecoration(
                                'First Name', 'Enter your first name'),
                            validator: (val) {
                              int? x = val?.length;
                              if (x! > 20) {
                                return "user name cant be larger than 20 letter";
                              }
                              if (x! < 2) {
                                return "user name cant be less than 3 letter";
                              }
                              if (val!.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (val) {
                              lastname = val;
                            },
                            decoration: ThemHelper().textInputDecoration(
                                'Last Name', 'Enter your last name'),
                            validator: (val) {
                              int? x = val?.length;
                              if (x! > 20) {
                                return "user name cant be larger than 20 letter";
                              }
                              if (x! < 2) {
                                return "user name cant be less than 3 letter";
                              }

                              if (val!.isEmpty) {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: h * 0.03),
                        Container(
                          alignment: Alignment.topLeft,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Text(
                            "Selectioner une spécialité :",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 17),
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 17, vertical: 2),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: specialite,
                              isExpanded: true,
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (item) =>
                                  setState(() => specialite = item),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        // Container(
                        //   child: Specialite(),
                        //   // decoration: ThemHelper().inputBoxDecorationShaddow(),
                        // ),
                        SizedBox(height: h * 0.03),
                        Container(
                          child: TextFormField(
                            onSaved: (val) {
                              phone = val;
                            },
                            decoration: ThemHelper().textInputDecoration(
                                "Mobile Number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              int? x = val?.length;
                              if (x! != 10) {
                                return "Phone should be in 10 digits";
                              }
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: h * 0.03),
                        Container(
                          child: TextFormField(
                            onSaved: (val) {
                              email = val;
                            },
                            decoration: ThemHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: h * 0.03),
                        Container(
                          child: TextFormField(
                            onSaved: (val) {
                              password = val;
                            },
                            obscureText: true,
                            decoration: ThemHelper().textInputDecoration(
                                "Password", "Enter your password"),
                            validator: (val) {
                              int? x = val?.length;
                              if (x! > 20) {
                                return "password cant be larger than 20 letter";
                              }
                              if (x! < 8) {
                                return "password cant be smaller than 8 letter";
                              }

                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: h * 0.03),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text("Our terms and conditions :",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                SizedBox(height: 16),
                                buildText(
                                    "1.   Avoid discussing anything illegal or prohibited by law in our country and sensitive subjects                                         2. Mutual respect is mandatory, all kinds of hate speech, harassment or racism are not tolerated, make sure to not reveal any personal information about another user.and it results to exclusion,                    3.   Constructive criticism is always welcome.                                                                                 4. Keep in mind that receiving 3 warnings for breaking rules will lead to severe consequences                                                                      5.   If you have any problem or feedback/suggestions, make sure to contact us."),
                                SizedBox(height: 16),
                                buildBotton(),
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: h * 0.04),
                        Container(
                          decoration: ThemHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                              style: ThemHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Register".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (specialite == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemHelper().alartDialog(
                                          "Specialité:",
                                          "Selectioner une spécialité svp!.",
                                          context);
                                    },
                                  );
                                }

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmation:"),
                                      content: Text(
                                          "Are you sure your informations?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("CANCEL")),
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              signUp();
                                            },
                                            child: Text("CONFIRMER"))
                                      ],
                                    );

                                    ;
                                  },
                                );
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (context) => HomePgae()),
                                //     (Route<dynamic> route) => false);

                                // if (_formKey.currentState!.validate() &&
                                //     specialite != null) {
                                //   var formdata = _formKey.currentState;

                                //   formdata?.save();

                                //   try {
                                //     userCredential = await FirebaseAuth.instance
                                //         .createUserWithEmailAndPassword(
                                //       email: email,
                                //       password: password,
                                //     );
                                //     Navigator.pushReplacementNamed(
                                //         context, "home");

                                //     //   User? user = FirebaseAuth
                                //     //                 .instance.currentUser;
                                //     //             await user?.sendEmailVerification();
                                //     //             showDialog(
                                //     //                 context: context,
                                //     //                 builder:
                                //     //                     (BuildContext context) {
                                //     //                   return ThemHelper().alartDialog(
                                //     //                       "Email verification:",
                                //     //                       "We have sent a mail to your email to verify it.",
                                //     //                       context);
                                //     //                 },
                                //     //               );
                                //     //                if (userCredential
                                //     //                   .user?.emailVerified ==
                                //     //               true){print(userCredential.user?.emailVerified);
                                //     //               print("==================================");
                                //     //  Navigator.pushReplacementNamed(context, "home");}
                                //   } on FirebaseAuthException catch (e) {
                                //     if (e.code == 'weak-password') {
                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return ThemHelper().alartDialog(
                                //               "Password",
                                //               "The password provided is too weak.",
                                //               context);
                                //         },
                                //       );
                                //       print(
                                //           'The password provided is too weak.');
                                //     } else if (e.code ==
                                //         'email-already-in-use') {
                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return ThemHelper().alartDialog(
                                //               "Email",
                                //               "The account already exists for that email.",
                                //               context);
                                //         },
                                //       );
                                //       print(
                                //           'The account already exists for that email.');
                                //     } else {
                                //       print(e);

                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return ThemHelper().alartDialog(
                                //               "erreur",
                                //               e.toString().replaceAll(
                                //                   "[firebase_auth/invalid-email]",
                                //                   ""),
                                //               context);
                                //         },
                                //       );
                                //     }
                                //   }

                                //   //  if (userCredential
                                //   //                 .user?.emailVerified ==
                                //   //             false) {
                                //   //           User? user = FirebaseAuth
                                //   //               .instance.currentUser;
                                //   //           await user?.sendEmailVerification();
                                //   //           showDialog(
                                //   //               context: context,
                                //   //               builder:
                                //   //                   (BuildContext context) {
                                //   //                 return ThemHelper().alartDialog(
                                //   //                     "Email verification:",
                                //   //                     "We have sent a mail to your email to verify it.",
                                //   //                     context);
                                //   //               },
                                //   //             );
                                //   //         }

                                // }
                              }),
                        ),
                        SizedBox(height: h * 0.05),
                      ],
                    ),
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

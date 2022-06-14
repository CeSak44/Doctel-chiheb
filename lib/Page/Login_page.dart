import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Page/Registration_pageForDoc.dart';
import 'package:flutter_application_1/common/them_helper.dart';
import 'package:flutter_application_1/homepage.dart';
import 'Widgets/Header_widget.dart';
import 'forgot_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
//   IconData set =ImageIcon(
//      AssetImage("images/LogoWhite.png"),
// ) as IconData;
  late UserCredential userCredential;
  var emaill, passwordd;
  bool? isAccepted;
  String? num;
  var x;

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

  // sendNotfiy(String title,String body)async{
  //   await http.post(
  //     Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //    headers: <String, String>{
  //      'Content-Type': 'application/json',
  //      'Authorization': 'key=AAAANvnvhFo:APA91bG4r3hFPR05rztO0T5J0Ss92MMma7lpdYBcDzyeeDVOXBwTcm83aOVeY9HQoXegpaUhdmxbwhB3oebkCx5dVIcU--ZC8qz6k6b7FIrz8FxFOM84r0JKxFtZ1i_eeWTKzqT34ZcB',
  //    },
  //    body: jsonEncode(
  //    <String, dynamic>{
  //      'notification': <String, dynamic>{
  //        'body': body.toString(),
  //        'title': title.toString()
  //      },
  //      'priority': 'high',
  //      'data': <String, dynamic>{
  //        'click_action': 'FLUTTER_NOTIFICATION_CLICK',

  //      },
  //      'to': await FirebaseMessaging.instance.getToken(),
  //    },
  //   ),
  // );
  // }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                      height: h * 0.32,
                      child: HeaderWidget(
                        h * 0.33,
                        false,
                        Icons.person,
                      )),
                  Center(
                    child: Container(
                        height: h * 0.25,
                        width: w * 0.2,
                        child: Center(
                          child: Image(
                            image: AssetImage("img/LogoWhite.png"),
                          ),
                        )),
                  ),
                ],
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //The login form
                    child: Column(
                      children: [
                        Container(
                            height: h * 0.12,
                            child:
                                Image(image: AssetImage("img/blueLogo.png"))),
                        Text(
                          "Sign into your account",
                          style: TextStyle(color: Colors.grey),
                        ),
                        // Text(
                        //   "DocTell",
                        //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                        // ),
                        SizedBox(
                          height: h * 0.015,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  child: TextFormField(
                                    onSaved: (val) {
                                      emaill = val;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: ThemHelper()
                                        .textInputDecoration(
                                            'Email', 'Enter your email'),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your email";
                                      }
                                      if (!(val!.isEmpty) &&
                                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                              .hasMatch(val)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Container(
                                  child: TextFormField(
                                    onSaved: (val) {
                                      passwordd = val;
                                    },
                                    obscureText: true,
                                    decoration: ThemHelper()
                                        .textInputDecoration(
                                            'Password', 'Enter your password'),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your password";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: h * 0.018,
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordPage()),
                                      );
                                    },
                                    child: Text(
                                      "Forgot your password?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration:
                                      ThemHelper().buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                      style: ThemHelper().buttonStyle(),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: Text(
                                          'sign in'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // await sendNotfiy("title", "body");
                                        _formKey.currentState?.save();
                                        print("====================");
                                        print(emaill);
                                        /////////// use sign in
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            showLoading(context);
                                            userCredential = await FirebaseAuth
                                                .instance
                                                .signInWithEmailAndPassword(
                                                    email: emaill,
                                                    password: passwordd);

                                            print(
                                                "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");

                                            //  await  FirebaseFirestore.instance
                                            //       .collection("Docuser").doc("0hjS2QFEgTMDOfCc6GdU").get().then((value) =>
                                            //       print(value.data()?["isAccepted"]));

                                            await FirebaseFirestore.instance
                                                .collection("Docuser")
                                                .where("email",
                                                    isEqualTo: emaill)
                                                .get()
                                                .then((value) {
                                              value.docs.forEach((element) {
                                                isAccepted = element
                                                    .data()["isAccepted"];
                                              });
                                            });
                                            await FirebaseFirestore.instance
                                                .collection("Docuser")
                                                .where("email",
                                                    isEqualTo: emaill)
                                                .get()
                                                .then((value) {
                                              value.docs.forEach((element) {
                                                x = element.data()["email"];
                                              });
                                            });
                                            bool? exist;
                                              await FirebaseFirestore.instance
                                                  .collection("Docuser")
                                                  .where("email",
                                                      isEqualTo: emaill)
                                                  .get()
                                                  .then((value) {
                                                value.docs.forEach((element) {
                                                  exist = (element.data()["wilaya"] != "");
                                                });
                                              });
                                            print(exist);
                                            if (isAccepted != null &&
                                                x != null) {
                                              print(
                                                  "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");

                                              if (FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .emailVerified &&
                                                  isAccepted!) {
                                                Navigator.pushReplacementNamed(
                                                    context, "splash");
                                              } else if (exist == false) {
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacementNamed(
                                                    context, "adress");
                                              }else if (!FirebaseAuth.instance
                                                  .currentUser!.emailVerified) {
                                                Navigator.pushReplacementNamed(
                                                    context, "verify");
                                              }  else if (isAccepted == false) {
                                                Navigator.of(context).pop();
                                                await FirebaseAuth.instance
                                                    .signOut();

                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ThemHelper().alartDialog(
                                                        "Erreur:",
                                                        "you are not accepted yet.",
                                                        context);
                                                  },
                                                );
                                              }
                                            } else {
                                              Navigator.of(context).pop();

                                              await FirebaseAuth.instance
                                                  .signOut();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ThemHelper().alartDialog(
                                                      "Erreur:",
                                                      "It is a patiant account !!.",
                                                      context);
                                                },
                                              );
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code == 'user-not-found') {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ThemHelper().alartDialog(
                                                      "Erreur:",
                                                      "No user found for that email.",
                                                      context);
                                                },
                                              );
                                              print(
                                                  'No user found for that email.');
                                            } else if (e.code ==
                                                'wrong-password') {
                                              Navigator.of(context).pop();

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ThemHelper().alartDialog(
                                                      "Erreur:",
                                                      "Wrong password provided for that user.",
                                                      context);
                                                },
                                              );
                                              print(
                                                  'Wrong password provided for that user.');
                                            }
                                            // else {
                                            //   Navigator.of(context).pop();

                                            //   showDialog(
                                            //     context: context,
                                            //     builder:
                                            //         (BuildContext context) {
                                            //       return ThemHelper()
                                            //           .alartDialog(
                                            //               "erreur",
                                            //               e.message.toString(),
                                            //               context);
                                            //     },
                                            //   );
                                            // }
                                          }

                                          ////////////////////////////

                                          //// creating users
                                          /////////////////
                                          //     try {
                                          //       userCredential = await FirebaseAuth
                                          //           .instance
                                          //           .createUserWithEmailAndPassword(
                                          //         email: email,
                                          //         password: password,
                                          //       );
                                          //       print(userCredential);
                                          //     } on FirebaseAuthException catch (e) {
                                          //       if (e.code == 'weak-password') {
                                          //         print(
                                          //             'The password provided is too weak.');
                                          //       } else if (e.code ==
                                          //           'email-already-in-use') {
                                          //              showDialog(
                                          //   context: context,
                                          //   builder: (BuildContext context) {
                                          //     return ThemHelper().alartDialog(
                                          //         "Email",
                                          //         "The account already exists for that email.",
                                          //         context);
                                          //   },
                                          // );
                                          //         print(
                                          //             'The account already exists for that email.');
                                          //       }
                                          //     } catch (e) {
                                          //       print(e);
                                        }
                                      }
                                      // },
                                      ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  //  child:Text("Don't have an account? Create!"),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(text: "Don't have an account?"),
                                    TextSpan(
                                      text: "Create!",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegistrationPageForDoc()));
                                        },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                  ])),
                                )
                              ],
                            ))
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buttonBoxDecoration(BuildContext context) {}

  forgotPasswordPage() {}
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Widgets/app_header.dart';
import 'Widgets/go_back_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController sampledata1 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double rate=3;
    const defaultPadding = 10.0;
    const primarycolor = Colors.lightBlue;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const AppHeader(),
            const Positioned(
                top: -380,
                bottom: -187,
                child: Opacity(opacity: 0.9, child: Text('Feedback'))),
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding * 2),
                  child: Column(
                    children: [
                      const GoBackButton(),
                      const SizedBox(
                        height: defaultPadding * 4,
                      ),
                      const Text(
                        'Feedback',
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat'),
                      ),
                      const SizedBox(
                        height: defaultPadding * 7,
                      ),
                      const Text(
                        "did you encounter any problems? do not hesitate to contact us, we will answer you as soon as possible. We would like your opinion to improve our service!",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding * 2,
                      ),
                      const Text(
                        'How do you rate our app?',
                        style: TextStyle(fontSize: 22 , fontWeight: FontWeight.w700 , color: Colors.black,),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: primarycolor,
                        ),
                        onRatingUpdate: (rating) {
                          rate = rating;
                          print(rating);
                        },
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Container(
                        padding: const EdgeInsets.all(defaultPadding * 1.5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 15,
                                offset: Offset(0, 15),
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                              )
                            ]),
                        child: TextFormField(
                          controller: sampledata1,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Feedback Here',
                          ),
                          validator: (String? text) {
                            if (text == null || text.isEmpty) {
                              return 'You Should Enter Feedback';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextButton(
                            onPressed: () {
                              if(sampledata1.text.isNotEmpty){
                                String message;
                                try{
                                  FirebaseFirestore.instance.collection("feedback").add({"feedback":sampledata1.text , "time":DateTime.now() , "rating":rate});
                                  message = "Your feedback has been sent succesfully";
                                }
                                catch(_){
                                  message = "Write Your Feedback";
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(message)));
                              }
                            },
                            child: const Text(
                              'Send !',
                              style: TextStyle(fontSize: 22),
                            )),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
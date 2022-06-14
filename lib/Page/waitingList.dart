import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../common/them_helper.dart';
import 'Docter_Profil/Header_widget.dart';

class waitingList extends StatefulWidget {
  const waitingList({ Key? key }) : super(key: key);

  @override
  State<waitingList> createState() => _waitingListState();
}

class _waitingListState extends State<waitingList> {
  @override
  Widget build(BuildContext context) {
     double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
  return Scaffold(
              backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: h*0.35,
                child: HeaderWidget(
                  h*0.35, true, Icons.sentiment_very_satisfied_outlined),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your rquest has been sent',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: h*0.1,),
                            
                            Text(
                              'You will be able to access the application once an admin approve your request!.',
                              style: TextStyle(
                                
                                fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h*0.2),
                       TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, "login");
                    },
                    style:
                        ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50),),
                      
                    child: Text(
                      "Retour".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),                    SizedBox(height: h*0.01),

                      Text(
                              'Thank you for chosing our application!.',
                              style: TextStyle(
                                // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
}
}
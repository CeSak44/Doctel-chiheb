import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

import '../Docter_Profil/profil_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search..'),
              onChanged: (val){
                setState((){
                  name = val;
                  print("changed");
                });
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: (name == "")
              ?FirebaseFirestore.instance.collection("Docuser").snapshots()
              :FirebaseFirestore.instance.collection("Docuser")
          .where("firstname",isGreaterThanOrEqualTo: name )
          .where("firstname", isLessThan: name + 'z')
              .snapshots(),
          builder: (context , snapshot){
            return(snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator(),)
                : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context , index){
                  DocumentSnapshot data = snapshot.data!.docs[index];
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 2,
                      shadowColor: const Color.fromARGB(255, 63, 63, 63),
                      borderRadius: BorderRadius.circular(19),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Dr."+ data["firstname"]+" "+data["lastname"]),
                            subtitle: Text(data["specialité"]),
                            leading: ClipOval(
                                        child: data["picture"] != ""
                                            ? Image.network(
                                                data["picture"],
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.14,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .17,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                Icons.person,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                color: Colors.grey.shade400,
                                              ),
                                      ),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            onTap:(){
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DoctorPage(
                                            first: data["firstname"]+" "+data["lastname"],
                                            last: data["lastname"],
                                            uid: data["owner"],
                                            url: data["picture"],
                                            spec: data["specialité"],
                                            phone: data["phone"],
                                            email: data["email"],
                                            about: data["about"],
                                          )),
                                );
                            } ,
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        )
    );
  }
}
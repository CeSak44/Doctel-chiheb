import 'package:cote_pat/Page/Docter_Profil/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import './profil_page.dart';

class BioTableList extends StatelessWidget {
  const BioTableList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                ...ListTile.divideTiles(
                  color: Colors.grey,
                  tiles: [
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                      leading: Icon(Icons.category),
                      title: Text("Specialité"),
                      subtitle: Text("$s"),
                    ),
                    ListTile(
                      onTap: () {
                        _callNumber();
                      },
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      leading: const Icon(Icons.phone),
                      title: const Text("Phone"),
                      subtitle: Text("${p}"),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      leading: Icon(Icons.email),
                      title: Text("Email"),
                      subtitle: Text("$e"),
                    ),
                    ListTile(
                      onTap: () {
                        MapsLauncher.launchCoordinates(
                            35.18359755545525, -0.6482344025623622);
                      },
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      leading: const Icon(Icons.my_location),
                      title: Text("$adress"),
                      subtitle: const Text("click to show directions"),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                      leading: Icon(Icons.person),
                      title: Text("About Me"),
                      subtitle: Text(aa == "" ? "Bio is empty" : "${aa}"),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

_callNumber() async {
  //  number = p; //set the number here
  bool? res = await FlutterPhoneDirectCaller.callNumber(p!);
}

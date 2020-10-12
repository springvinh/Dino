import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final auth = FirebaseAuth.instance;
final database = FirebaseDatabase.instance.reference();
List<dynamic> deviceNames;
List<dynamic> count;
String userID;

class MePage extends StatefulWidget {
  @override
  MeState createState() => MeState();
}

class MeState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'Tôi',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
                child: FutureBuilder(
              future: auth.currentUser(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return Container();
                }

                userID = snapshot.data.uid;

                return new StreamBuilder(
                  stream: database.child('users').child(userID).onValue,
                  builder: (context, event) {
                    if (!event.hasData) {
                      return Container();
                    }

                    Map<dynamic, dynamic> user = event.data.snapshot.value;
                    Map<dynamic, dynamic> devices = user['devices'];

                    deviceNames = [];
                    count = [];

                    devices.forEach((keys, values) {
                      deviceNames.add(values['name']);
                      count.add(values['count']);
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  new ClipRRect(
                                    borderRadius: BorderRadius.circular(200.0),
                                    child: Container(
                                      width: 150.0,
                                      height: 150.0,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.network(user['avatarUrl']),
                                      ),
                                    ),
                                  ),
                                  // new CircleAvatar(
                                  //   backgroundImage:
                                  //       NetworkImage(user['avatarUrl']),
                                  // ),
                                  new SizedBox(height: 20.0),
                                  new Text(user['name'],
                                      style: TextStyle(fontSize: 18.0)),
                                  new Text(
                                    user['email'],
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black87),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                              left: 24.0, right: 24.0, top: 10.0),
                          child: Text(
                            'Thiết bị đã sử dụng',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: deviceNames.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 18.0),
                                margin: EdgeInsets.only(bottom: 24.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.0),
                                    border: Border.all(
                                        width: 2.0,
                                        color:
                                            Color.fromARGB(50, 100, 100, 100))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Icon(Icons.local_drink),
                                    new SizedBox(width: 12.0),
                                    new Text(deviceNames[index]),
                                    new Spacer(),
                                    new Text(
                                      'Số lần: ${count[index]}',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ))));
  }
}

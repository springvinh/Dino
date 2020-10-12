import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

final auth = FirebaseAuth.instance;
final database = FirebaseDatabase.instance.reference();
Map<dynamic, dynamic> users;
List<dynamic> userKeys;
List<dynamic> userNames;
List<dynamic> userEmails;
List<dynamic> userAccess;
List<dynamic> userAvatars;
List<dynamic> theOnes;
String userID;

class ManagePage extends StatefulWidget {
  @override
  ManageState createState() => ManageState();
}

class ManageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Quản lý người dùng',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.8,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: auth.currentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingBouncingGrid.square(
                  size: 36.0,
                  backgroundColor: Colors.black87,
                  inverted: true,
                ),
              );
            }

            userID = snapshot.data.uid;

            return StreamBuilder(
              stream: database.child('users').child(userID).onValue,
              builder: (context, event) {
                if (!event.hasData) {
                  return Container();
                }

                Map<dynamic, dynamic> user = event.data.snapshot.value;

                if (user['TheOneAboveAll'] != true) {
                  return Center(
                    child: Text('Bạn không có quyền quản lý!'),
                  );
                }

                if (user['TheOneAboveAll'] == true) {
                  return StreamBuilder(
                    stream: database.child('users').onValue,
                    builder: (context, event) {
                      if (!event.hasData) {
                        return Container();
                      }

                      Map<dynamic, dynamic> users = event.data.snapshot.value;

                      userKeys = [];
                      userNames = [];
                      userEmails = [];
                      userAccess = [];
                      userAvatars = [];
                      theOnes = [];

                      users.forEach((keys, values) {
                        userKeys.add(keys);
                        userNames.add(values['name']);
                        userEmails.add(values['email']);
                        userAccess.add(values['access']);
                        userAvatars.add(values['avatarUrl']);
                        theOnes.add(values['TheOneAboveAll']);
                      });

                      return ListView.builder(
                        itemCount: userKeys.length,
                        itemBuilder: (context, index) {
                          return ListBody(
                            children: <Widget>[
                              new ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userAvatars[index]),
                                ),
                                title: Text(userNames[index]),
                                subtitle: Text(userEmails[index]),
                              ),
                              new SizedBox(
                                height: 6,
                              ),
                              new Container(
                                height: 45.0,
                                color: Color.fromARGB(10, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    new Container(
                                      height: 45.0,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          onTap: () {
                                            if (userID ==
                                                userKeys[index].toString()) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Không thể thay đổi quyền của bản thân!')));
                                            } else {
                                              accessChange(userKeys[index]);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24.0),
                                            child: Row(
                                              children: <Widget>[
                                                new Icon(Icons.block,
                                                    size: 18.0,
                                                    color: userAccess[index] !=
                                                            null
                                                        ? Colors.black
                                                        : Colors.black38),
                                                new SizedBox(width: 8.0),
                                                new Text(
                                                    userAccess[index] != true
                                                        ? 'CHO PHÉP'
                                                        : 'CHẶN',
                                                    style: userAccess[index] !=
                                                            true
                                                        ? TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.black38)
                                                        : TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      height: 45.0,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          onTap: () {
                                            if (userID ==
                                                userKeys[index].toString()) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Không thể thay đổi quyền của bản thân!')));
                                            } else {
                                              theOneChange(userKeys[index]);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24.0),
                                            child: Row(
                                              children: <Widget>[
                                                new Icon(Icons.verified_user,
                                                    size: 18.0,
                                                    color:
                                                        theOnes[index] != null
                                                            ? Colors.red
                                                            : Colors.black38),
                                                new SizedBox(width: 8.0),
                                                new Text(
                                                    theOnes[index] != true
                                                        ? 'ĐẶT LÀM QUẢN TRỊ VIÊN'
                                                        : 'QUẢN TRỊ VIÊN',
                                                    style: theOnes[index] !=
                                                            true
                                                        ? TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.black38)
                                                        : TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.red))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Divider(
                                height: 0,
                                thickness: 0.5,
                              ),
                              new SizedBox(height: 10)
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

accessChange(key) async {
  var userRef = database.child('users').child(key);

  userRef.child('access').once().then((onValue) {
    if (onValue.value == true) {
      userRef.update({'access': null});
      userRef.update({'TheOneAboveAll': null});
    }

    if (onValue.value == null) {
      userRef.update({'access': true});
    }
  });
}

theOneChange(key) async {
  var userRef = database.child('users').child(key);

  userRef.child('TheOneAboveAll').once().then((onValue) {
    if (onValue.value == true) {
      userRef.update({'TheOneAboveAll': null});
    }

    if (onValue.value == null) {
      userRef.update({'TheOneAboveAll': true});
    }
  });
}

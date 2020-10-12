import 'dart:async';
import 'package:dino/page/history.dart';
import 'package:dino/page/manage.dart';
import 'package:dino/page/me.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';

final auth = FirebaseAuth.instance;
final database = FirebaseDatabase.instance.reference();
Map<dynamic, dynamic> devices;
Map<dynamic, dynamic> user;
List<dynamic> deviceKeys;
List<dynamic> deviceNames;
List<dynamic> deviceStates;
String userID;
String currentVersion = '1.0.2';

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<Event> version;

  signOut() async {
    try {
      await auth.signOut();
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();

    version = database.child('app').onValue.listen((onData) {
      setState(() {
        if (onData.snapshot.value['version'] != currentVersion) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Text('Đã có phiên bản mới!'),
            action: SnackBarAction(
              label: 'DOWNLOAD',
              textColor: Colors.blue,
              onPressed: () async {
                await FlutterWebBrowser.openWebPage(
                    url: onData.snapshot.value['link'],
                    androidToolbarColor: Colors.white);
              },
            ),
          ));
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    version.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(5, 0, 0, 0),
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
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
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      if (snapshot.data.snapshot.value['access'] != true &&
                          snapshot.data.snapshot.value['TheOneAboveAll'] !=
                              true) {
                        return Container(
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top,
                          child: Center(
                            child: Text(
                                'Bạn đã bị mất quyền điều khiển thiết bị!'),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 50.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text('Hi there,',
                                      style: TextStyle(
                                          color: Color.fromARGB(170, 0, 0, 0),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700)),
                                  new SizedBox(height: 5.0),
                                  new Text('What are you looking for?',
                                      style: TextStyle(
                                          color: Color.fromARGB(170, 0, 0, 0),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700)),
                                ],
                              )),
                          new Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              margin: EdgeInsets.only(bottom: 24.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 15.0,
                                        spreadRadius: 5.0,
                                        offset: Offset(6.0, 6.0))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  toolBarItem(Icons.person_outline, 'Tôi', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MePage()));
                                  }),
                                  toolBarItem(Icons.history, 'Lịch sử', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HistoryPage()));
                                  }),
                                  toolBarItem(Icons.verified_user, 'Quản lý',
                                      () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManagePage()));
                                  }),
                                  toolBarItem(Icons.arrow_forward, 'Đăng xuất',
                                      () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            width: double.infinity,
                                            height: 163.0,
                                            padding: EdgeInsets.all(24.0),
                                            color: Colors.white,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Text(
                                                  'Đăng xuất',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                new SizedBox(height: 14.0),
                                                new Text(
                                                    'Bạn có muốn đăng xuất không?'),
                                                new SizedBox(height: 14.0),
                                                new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    new FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'HỦY BỎ',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    new FlatButton(
                                                      onPressed: () {
                                                        signOut();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'ĐĂNG XUẤT',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      );
                                  })
                                ],
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Text(
                              'Thiết bị hiện có',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          new Padding(
                              padding: EdgeInsets.all(24.0),
                              child: StreamBuilder(
                                stream: database.child('devices').onValue,
                                builder: (context, event) {
                                  if (!event.hasData) {
                                    return Container();
                                  }

                                  devices = event.data.snapshot.value;

                                  deviceKeys = [];
                                  deviceNames = [];
                                  deviceStates = [];

                                  devices.forEach((keys, values) {
                                    deviceKeys.add(keys);
                                    deviceNames.add(values['name']);
                                    deviceStates.add(values['status']);
                                  });

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: deviceKeys.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 24.0),
                                        child: InkWell(
                                          onTap: () {
                                            deviceCardOnTap(deviceKeys[index],
                                                deviceNames[index]);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 18.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: Color.fromARGB(
                                                        50, 100, 100, 100))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                new Icon(Icons.local_drink),
                                                new SizedBox(width: 12.0),
                                                new Text(deviceNames[index]),
                                                new Spacer(),
                                                new Text(
                                                  deviceStates[index] == 'off'
                                                  ? 'LOCK'
                                                  : 'UNLOCK',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ))
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}

deviceCardOnTap(key, name) async {
  FirebaseUser user = await auth.currentUser();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm EEEE d MMMM').format(now);

  var deviceRef = database.child('devices').child(key);
  var userRef = database.child('users').child(user.uid);
  var userDeviceRef =
      database.child('users').child(user.uid).child('devices').child(key);
  var historyRef = database.child('history');

  deviceRef.child('status').once().then((DataSnapshot snapshot) {
    var state = snapshot.value;

    if (state == 'off') {
      deviceRef.update({'status': 'on'});

      userDeviceRef.child('count').once().then((DataSnapshot snapshot) {
        var count = snapshot.value;

        if (count == null) {
          userDeviceRef.update({
            'name': name,
            'count': 1,
          });
        } else {
          userDeviceRef.update({'count': count + 1});
        }
      });
    }

    if (state == 'on') {
      deviceRef.update({'status': 'off'});
    }

    userRef.once().then((DataSnapshot snapshot) {
      var userName = snapshot.value['name'];
      var userAvatar = snapshot.value['avatarUrl'];

      historyRef.push().set({
        'userAvatar': userAvatar,
        'userName': userName,
        'deviceName': name,
        'state': state == 'off' ? 'Unlock' : 'Lock',
        'time': formattedDate
      });
    });
  });
}

Widget toolBarItem(IconData icon, String label, Function function) {
  return GestureDetector(
    onTap: function,
    child: Column(
      children: <Widget>[
        new Icon(icon),
        new SizedBox(height: 3.0),
        new Text(
          label,
          style: TextStyle(fontSize: 12.0),
        )
      ],
    ),
  );
}

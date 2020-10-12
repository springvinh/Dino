import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final database = FirebaseDatabase.instance.reference();
Map<dynamic, dynamic> historyDatas;
List<dynamic> userAvatars;
List<dynamic> userNames;
List<dynamic> deviceNames;
List<dynamic> times;
List<dynamic> states;

class HistoryPage extends StatefulWidget {
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<HistoryPage> {
  StreamSubscription<Event> history;

  @override
  void initState() {
    super.initState();

    userAvatars = [];
    userNames = [];
    deviceNames = [];
    times = [];
    states = [];

    history = database
        .child('history')
        .orderByKey()
        .limitToLast(20)
        .onChildAdded
        .listen((onData) {
      historyDatas = onData.snapshot.value;

      setState(() {
        userAvatars.insert(0, historyDatas['userAvatar']);
        userNames.insert(0, historyDatas['userName']);
        deviceNames.insert(0, historyDatas['deviceName']);
        times.insert(0, historyDatas['time']);
        states.insert(0, historyDatas['state']);
      });
    });
  }

  @override
  void dispose() {
    history.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Lịch sử',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.8,
        backgroundColor: Colors.white,
      ),
      body: Container(
          color: Colors.white,
          child: ListView.separated(
            itemCount: userNames.length == null ? 0 : userNames.length,
            itemBuilder: (context, index) {
              return materialItemBuilder(userAvatars[index] ,userNames[index], times[index],
                  states[index], deviceNames[index]);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          )),
    );
  }
}

Widget materialItemBuilder(String userAvatar, String userName, String time, String state, String deviceName) {
  return ListBody(
    children: <Widget>[
      new ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            userAvatar == null
            ? 'https://almcharities.com/wp-content/uploads/2019/05/placeholder-circle.png'
            : userAvatar
          ),
        ),
        title: Text(userName),
        subtitle: Text(time),
      ),
      new ListTile(
        title: Text(deviceName),
        trailing: Text(state),
      )
    ],
  );
}
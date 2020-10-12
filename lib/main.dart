import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dino/page/home.dart';
import 'package:dino/page/sign_in.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ProductSansRegular',
        primaryColor: Color(0xff000000),
        accentColor: Color.fromARGB(10, 0, 0, 0),
        cursorColor: Color(0xffffcc00),
      ),
      title: 'Dino',
      home: Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
                    
            if (snapshot.connectionState == ConnectionState.active) {

              FirebaseUser user = snapshot.data;

                if (user == null) {
                  return SignInPage();
                }

                return HomePage();

            }  else {

              return Center(
                child: CircularProgressIndicator(),
              );

            }
          }
        )
      )
    );             
  }
}


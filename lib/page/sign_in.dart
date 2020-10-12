import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dino/page/sign_up.dart';

final auth = FirebaseAuth.instance;
String email;
String password;

Future<void> signInWithEmailAndPassword(BuildContext context) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  } catch (error) {
    String errorMessage = error.message.toString();
    print(errorMessage);
    switch (errorMessage) {
      case 'Given String is empty or null':
        errorMessage = 'Bạn chưa nhập email hoặc mật khẩu.';
        break;
      case 'null':
        errorMessage = 'Bạn chưa nhập email hoặc mật khẩu.';
        break;
      case 'The email address is badly formatted.':
        errorMessage = 'Định dạng email không đúng.';
        break;
      case 'The password is invalid or the user does not have a password.':
        errorMessage = 'Mật khẩu không đúng.';
        break;
      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        errorMessage = 'Tài khoản không tồn tại.';
        break;
      default:
        errorMessage = 'Lỗi!';
    }

    Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
  }
}

class SignInPage extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        'Dino',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'ProductSansBold',
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      new GestureDetector(
                        child: Hero(
                          tag: 'signup',
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'ProductSansBold',
                              color: Colors.black54,
                              decoration: TextDecoration.none
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => SignUpPage())
                          );
                        },
                      )
                    ],
                  ),
                  new Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          'Hello!\nI\'m so glad to see you here',
                          style: TextStyle(
                            fontSize: 36.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => email = value,
                      ),
                      new SizedBox(
                        height: 24.0,
                      ),
                      new TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mật khẩu',
                          prefixIcon: Icon(Icons.lock)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        onChanged: (value) => password = value,
                      ),
                      new SizedBox(
                        height: 24.0,
                      ),
                      new GestureDetector(
                        onTap: () {
                          signInWithEmailAndPassword(context);
                        },
                        child: Container(
                          width: 170,
                          height: 50.0,
                          padding: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(3.0)
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                'ĐĂNG NHẬP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontFamily: 'ProductSansBold'
                                ),
                              ),
                              new Container(
                                width: 50.0,
                                height: 50.0,
                                color: Color.fromARGB(30, 255, 255, 255),
                                child: Icon(Icons.arrow_forward, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
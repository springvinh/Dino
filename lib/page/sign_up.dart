import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dino/page/sign_in.dart';

final database = FirebaseDatabase.instance.reference();
final storage = FirebaseStorage.instance;
final auth = FirebaseAuth.instance;
File imageFile;
String imagePath;
String name;
String email;
String password;

Future<void> createAccount(BuildContext context, String name) async {

  Random random = new Random();
  int intRandom1 = random.nextInt(1000000);
  int intRandom2 = random.nextInt(1000000);

  if (name != null && name != '') {

    try {

      await auth.createUserWithEmailAndPassword(email: email, password: password);

      FirebaseUser user = await auth.currentUser();

      if (imageFile != null) {

        StorageUploadTask uploadTask = storage.ref().child('UserAvatar').child('Avatar_${intRandom1.toString()}_${intRandom2.toString()}').putFile(imageFile);

        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        database.child('users').child(user.uid).set({
          'name': name, 'email': email, 'avatarUrl': downloadURL, 'access': true
        });

      } else {
        database.child('users').child(user.uid).set({
          'name': name, 'email': email, 'avatarUrl': 'https://firebasestorage.googleapis.com/v0/b/fir-esp32-e4efd.appspot.com/o/UserAvatar%2FUserAvatar738849?alt=media&token=de078089-37a9-4991-9f33-5fcd9c3bb758', 'access': true
        });
      }

      Navigator.pop(context, MaterialPageRoute(builder: (context) => SignInPage()));

    } catch (error) {

      String errorMessage = error.message;

      switch (errorMessage) {
        case 'The email address is already in use by another account.':
          errorMessage = 'Email đã được người khác sử dụng.';
          break;
        case 'The email address is badly formatted.':
          errorMessage = 'Định dạng email không đúng.';
          break;
        case 'The given password is invalid. [ Password should be at least 6 characters ]':
          errorMessage = 'Mật khẩu phải ít nhất 6 ký tự.';
          break;
        case 'Given String is empty or null':
          errorMessage = 'Bạn chưa nhập email hoặc mật khẩu.';
          break;
        default:
      }

      print(errorMessage);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage == null ? 'Lỗi' : errorMessage)));

    }

  } else {

    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Vui lòng điền đủ các mục!')));

  }

}

class SignUpPage extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {

    imageSelector() async {

      imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery
      );
      setState(() {
        imageFile = imageFile;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Hero(
                    tag: 'signup',
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'ProductSansBold',
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 70.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          imageSelector();
                        },
                        child: Column(
                          children: <Widget>[
                            chooseAvatar(imageFile),
                            new SizedBox(
                              height: 24.0,
                            ),
                            new Text(
                              'Chọn ảnh',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  new SizedBox(
                    height: 70.0,
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Họ và tên',
                        helperText: 'Họ và tên có dấu',
                        prefixIcon: Icon(Icons.person)),
                    onChanged: (value) => name = value,
                  ),
                  new SizedBox(
                    height: 24.0,
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        helperText: 'example@gmail.com',
                        prefixIcon: Icon(Icons.email)),
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
                        helperText: 'Độ dài tối thiểu 6 ký tự',
                        prefixIcon: Icon(Icons.lock)),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    onChanged: (value) => password = value,
                  ),
                  new SizedBox(
                    height: 24.0,
                  ),
                  new GestureDetector(
                    onTap: () {
                      createAccount(context, name);
                    },
                    child: Container(
                      width: 155,
                      height: 50.0,
                      padding: EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(3.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            'ĐĂNG KÝ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontFamily: 'ProductSansBold'),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget chooseAvatar(File file) {
  return new Stack(
    children: <Widget>[
      new ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: Color.fromARGB(20, 0, 0, 0),
            ),
            child: FittedBox(
              fit: BoxFit.cover,
              child: file == null
              ? new Image.network('https://firebasestorage.googleapis.com/v0/b/fir-esp32-e4efd.appspot.com/o/UserAvatar%2FUserAvatar738849?alt=media&token=de078089-37a9-4991-9f33-5fcd9c3bb758')
              : new Image.file(file),
            )),
      ),
      new Positioned(
        right: 5,
        bottom: 5,
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20.0)),
          child: Icon(Icons.image, color: Colors.white, size: 14.0),
        ),
      )
    ],
  );
}

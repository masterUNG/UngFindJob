import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungfindjob/utility/my_style.dart';
import 'package:ungfindjob/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  String type, name, user, password, uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
      ),
      body: ListView(
        children: <Widget>[
          MyStyle().mySizeBox(),
          nameForm(),
          MyStyle().mySizeBox(),
          companyRadio(),
          studentRadio(),
          MyStyle().mySizeBox(),
          userForm(),
          MyStyle().mySizeBox(),
          passwordForm(),
        ],
      ),
      floatingActionButton: registerButton(),
    );
  }

  FloatingActionButton registerButton() => FloatingActionButton(
        onPressed: () {
          if (name == null ||
              name.isEmpty ||
              user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Have Space', 'Please Fill Every Blank');
          } else if (type == null) {
            normalDialog(
                context, 'Non Choose Type', 'Please Tap Company or Student');
          } else {
            registerThread();
          }
        },
        backgroundColor: MyStyle().primaryColor,
        child: Icon(
          Icons.cloud_upload,
          size: 36.0,
        ),
      );

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: user, password: password)
        .then((value) {
      FirebaseUser firebaseUser = value.user;
      uid = firebaseUser.uid;
      print('Success Register Uid = $uid');
      insertValueFirestore();
    }).catchError((value) {
      String title = value.code;
      String message = value.message;
      normalDialog(context, title, message);
    });
  }

  Future<void> insertValueFirestore() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection(type);

    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Email'] = user;
    map['Uid'] = uid;

    await collectionReference
        .document(uid)
        .setData(map)
        .then((value) {
          print('Insert Success');
        })
        .catchError((value) {});
  }

  Widget companyRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: 'Company',
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                ),
                Text('Company')
              ],
            ),
          ),
        ],
      );

  Widget studentRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: 'Student',
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                ),
                Text('Student')
              ],
            ),
          ),
        ],
      );

  Widget nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => name = value.trim(),
            decoration: InputDecoration(
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Name :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget userForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => user = value.trim(),
            decoration: InputDecoration(
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'User :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget passwordForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => password = value.trim(),
            decoration: InputDecoration(
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Password :',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}

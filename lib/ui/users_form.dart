import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:microphone_flutterweb_example/ui/home.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _one = TextEditingController();
  String _two = "Option 1", _three = "Option 1";

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(currentUser.email).set({
      "answer 1": _one.text,
      "answer 2": _two,
      "answer 3": _three,
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Successfully stored to DB", toastLength: Toast.LENGTH_LONG);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    }).catchError((error) => Fluttertoast.showToast(
        msg: "Something is wrong", toastLength: Toast.LENGTH_LONG));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextFormField(
              controller: _one,
              decoration: InputDecoration(
                hintText: "hint one",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF414041),
                ),
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            DropdownButton<String>(
              value: _two,
              items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (selected) {
                setState(() {
                  _two = selected;
                });
              },
            ),
            SizedBox(
              height: 25,
            ),
            DropdownButton<String>(
              value: _three,
              items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (selected) {
                setState(() {
                  _three = selected;
                });
              },
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () => sendUserDataToDB(),
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}

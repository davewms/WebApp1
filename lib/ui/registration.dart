import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:microphone_flutterweb_example/ui/login.dart';
import 'package:microphone_flutterweb_example/ui/users_form.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      var authCredential = userCredential.user;
      print(authCredential.uid);
      if (authCredential.uid.isNotEmpty) {
        Fluttertoast.showToast(msg: "Success", toastLength: Toast.LENGTH_SHORT);
        Navigator.push(context, CupertinoPageRoute(builder: (_) => UserForm()));
      } else {
        Fluttertoast.showToast(
            msg: "Something is wrong", toastLength: Toast.LENGTH_LONG);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The password provided is too weak.",
            toastLength: Toast.LENGTH_LONG);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.",
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(
          children: [
            Text(
              "Create a new account",
              style: TextStyle(fontSize: 22, color: Colors.amber),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "thed9954@gmail.com",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF414041),
                ),
                labelText: 'EMAIL',
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "password must be 6 character",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF414041),
                ),
                labelText: 'PASSWORD',
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                ),
                suffixIcon: _obscureText == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = false;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 20,
                        ))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = true;
                          });
                        },
                        icon: Icon(
                          Icons.visibility_off,
                          size: 20,
                        )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => signUp(),
              child: Text("Create Account"),
            ),
            SizedBox(
              height: 40,
            ),
            Wrap(
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    "LogIn Now",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

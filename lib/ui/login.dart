import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:microphone_flutterweb_example/ui/home.dart';
import 'package:microphone_flutterweb_example/ui/registration.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      var authCredential = userCredential.user;
      print(authCredential.uid);
      if (authCredential.uid.isNotEmpty) {
        Fluttertoast.showToast(msg: "Success", toastLength: Toast.LENGTH_SHORT);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Something is wrong", toastLength: Toast.LENGTH_LONG);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No user found for that email.",
            toastLength: Toast.LENGTH_LONG);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user.",
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
              "Welcome Back",
              style: TextStyle(fontSize: 22, color: Colors.amber),
            ),
            Text(
              "Glad to see you back my buddy.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFBBBBBB),
              ),
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
              onPressed: () => signIn(),
              child: Text("Login Now"),
            ),
            SizedBox(
              height: 40,
            ),
            Wrap(
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    " Sign Up",
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
                            builder: (context) => RegistrationScreen()));
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

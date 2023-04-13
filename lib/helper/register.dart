import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketguide/helper/login.dart';
import 'package:pocketguide/screens/databse.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool hide = true;

  bool isLoading = false;

  hidePass() async {
    setState(() {
      hide = !hide;
    });
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await AuthService()
          .registerWithEmailAndPassword(_emailController.text,
              _passwordController.text, _nameController.text)
          .then((val) {
        if (val != null) {
          setState(() {
            isLoading = false;
          });

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        } else {
          emptyallField();
          setState(() {
            isLoading = false;
          });
        }
      });
      // Toast.show("Hello ${user.toString()}");
    }
  }

  emptyallField() async {
    _nameController.clear();
    _passwordController.clear();
    _emailController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(40),
      body: isLoading
          ? Center(
              child: Container(
                height: h * 0.05,
                width: w * 0.1,
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: w,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(20),
                  child: Stack(children: [
                    Positioned(
                      top: 15,
                      child: Container(
                          height: 60,
                          padding: EdgeInsets.all(2),
                          width: w - 50,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: Colors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          )),
                    ),
                    Positioned(
                      top: h * 0.28,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: w - 40,
                              child: TextFormField(
                                controller: _nameController,
                                obscureText: false,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.brown[400]!)),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                  errorStyle: TextStyle(
                                      fontSize: 16, color: Colors.amber),
                                  labelText: 'UserName',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: w - 40,
                              child: TextFormField(
                                enabled: true,
                                controller: _emailController,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.brown[400]!)),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                  errorStyle: TextStyle(
                                      fontSize: 16, color: Colors.amber),
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!value
                                      .toString()
                                      .contains("@gmail.com")) {
                                    return "Please enter a correct Email format";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: w - 40,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: hide ? true : false,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      await hidePass();
                                    },
                                    child: !hide
                                        ? Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                          ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.brown[400]!)),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                  errorStyle: TextStyle(
                                      fontSize: 16, color: Colors.amber),
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Please enter a Strong pass Or more then 6 character';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                                height: 50,
                                width: 100,
                                child: Card(
                                  child: TextButton(
                                    onPressed: _handleSignup,
                                    child: Text(
                                      'SignUp',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 82, 68, 68)),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: h * 0.15,
                        left: w * 0.1,
                        child: Row(
                          children: [
                            Text(
                              "Already have an Account?",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () => Get.to(() => LoginPage()),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.blue),
                                ))
                          ],
                        )),
                    Positioned(
                        top: h * 0.15,
                        left: 0,
                        child: Container(
                          height: 50,
                          width: w * 0.7,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  endIndent: 60,
                                  thickness: 1.7,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                        bottom: 20,
                        right: 0,
                        child: Container(
                          height: 50,
                          width: w * 0.7,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  indent: 60,
                                  thickness: 1.7,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ))
                  ]),
                ),
              ),
            ),
    );
  }
}

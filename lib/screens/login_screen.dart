import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:trinistocks_flutter/apis/profile_management_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController tokenController = new TextEditingController();
  TextEditingController verifyPasswordController = new TextEditingController();
  late FToast fToast;
  String cardView = "Login";
  late Card loginCardView;
  late Card registerCardView;
  late Card resetPasswordCardView;
  late Card resetPasswordConfirmCardView;

  Future<Map> tryLogin(String username, String password) {
    return ProfileManagementAPI.checkProvidedCredentials(username, password);
  }

  Future<String?> tryResetPassword(String email) {
    return ProfileManagementAPI.recoverPassword(email);
  }

  Future<String?> tryConfirmResetPassword(
      String token, String password1, String password2) {
    return ProfileManagementAPI.resetPassword(token, password1, password2);
  }

  Future<String?> trySignupUser(
      String username, String email, String password1, String password2) {
    return ProfileManagementAPI.signupUser(
        username, email, password1, password2);
  }

  Widget checkCardView() {
    if (cardView == "Login") {
      return loginCardView;
    } else if (cardView == "Reset Password") {
      return resetPasswordCardView;
    } else if (cardView == "Reset Password Confirm") {
      return resetPasswordConfirmCardView;
    } else if (cardView == "Register")
      return registerCardView;
    else
      return loginCardView;
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    loginCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.user,
                    size: 30,
                  ),
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                controller: usernameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 0,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.key,
                    size: 30,
                  ),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                controller: passwordController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: ElevatedButton(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    try {
                      if (usernameController.text == '') {
                        throw FormatException("Please enter a username!");
                      }
                      if (passwordController.text == '') {
                        throw FormatException("Please enter a password!");
                      }
                      isLoading = true;
                      tryLogin(usernameController.text, passwordController.text)
                          .then(
                        (Map returnValue) {
                          String? returnMessage = returnValue['message'];
                          isLoading = false;
                          if (returnMessage != null) {
                            fToast.showToast(
                              child: returnToast(returnMessage, false),
                              toastDuration: Duration(seconds: 5),
                              gravity: ToastGravity.BOTTOM,
                            );
                          } else {
                            fToast.showToast(
                              child: returnToast("Login Success!", true),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
                      );
                    } catch (e) {
                      fToast.showToast(
                        child: returnToast(e.toString(), false),
                        toastDuration: Duration(seconds: 5),
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      setState(() {
                        cardView = "Register";
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                    onPressed: () {
                      setState(() {
                        cardView = "Reset Password";
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    resetPasswordCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.envelopeOpen,
                    size: 30,
                  ),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.paperPlane),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Send Reset Email",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    onPressed: () {
                      try {
                        if (emailController.text == '') {
                          throw FormatException(
                              "Please enter an email address!");
                        }
                        isLoading = true;
                        tryResetPassword(emailController.text).then(
                          (String? returnValue) {
                            isLoading = false;
                            if (returnValue != null) {
                              fToast.showToast(
                                child: returnToast(returnValue, false),
                                toastDuration: Duration(seconds: 5),
                                gravity: ToastGravity.BOTTOM,
                              );
                            } else {
                              fToast.showToast(
                                child: returnToast(
                                    "Sent password reset email successfully! Please check your email inbox.",
                                    true),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 5),
                              );
                              setState(() {
                                cardView = "Reset Password Confirm";
                              });
                            }
                          },
                        );
                      } catch (e) {
                        fToast.showToast(
                          child: returnToast(e.toString(), false),
                          toastDuration: Duration(seconds: 5),
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Row(children: [
                      FaIcon(FontAwesomeIcons.arrowLeft),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Return to login"),
                      ),
                    ]),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                    ),
                    onPressed: () {
                      setState(() {
                        cardView = "Login";
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    resetPasswordConfirmCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.idBadge,
                    size: 30,
                  ),
                  labelText: 'Token',
                  border: OutlineInputBorder(),
                ),
                controller: tokenController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.key,
                    size: 30,
                  ),
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.key,
                    size: 30,
                  ),
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                controller: verifyPasswordController,
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.checkSquare),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Confirm Password Reset",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    onPressed: () {
                      try {
                        if (tokenController.text == '') {
                          throw FormatException("Please enter a token!");
                        }
                        if (passwordController.text == '') {
                          throw FormatException("Please enter a new password!");
                        }
                        if (verifyPasswordController.text == '') {
                          throw FormatException(
                              "Please enter reenter the new password!");
                        }
                        if (verifyPasswordController.text !=
                            passwordController.text) {
                          throw FormatException(
                              "Please ensure that both passwords match!");
                        }
                        isLoading = true;
                        tryConfirmResetPassword(
                                tokenController.text,
                                passwordController.text,
                                verifyPasswordController.text)
                            .then(
                          (String? returnValue) {
                            isLoading = false;
                            if (returnValue != null) {
                              fToast.showToast(
                                child: returnToast(returnValue, false),
                                toastDuration: Duration(seconds: 5),
                                gravity: ToastGravity.BOTTOM,
                              );
                            } else {
                              fToast.showToast(
                                child: returnToast(
                                    "Successfully reset password!", true),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 5),
                              );
                              setState(() {
                                cardView = "Login";
                              });
                            }
                          },
                        );
                      } catch (e) {
                        fToast.showToast(
                          child: returnToast(e.toString(), false),
                          toastDuration: Duration(seconds: 5),
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Row(children: [
                      FaIcon(FontAwesomeIcons.arrowLeft),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Return to login"),
                      ),
                    ]),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                    ),
                    onPressed: () {
                      setState(() {
                        cardView = "Login";
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    registerCardView = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.user,
                    size: 30,
                  ),
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                controller: usernameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.envelopeOpen,
                    size: 30,
                  ),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.key,
                    size: 30,
                  ),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 20,
                bottom: 10,
              ),
              child: TextFormField(
                style: TextStyle(decorationColor: Colors.red),
                decoration: const InputDecoration(
                  icon: FaIcon(
                    FontAwesomeIcons.key,
                    size: 30,
                  ),
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                controller: verifyPasswordController,
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.plusSquare),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Register New Account",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: () {
                      try {
                        if (usernameController.text == '') {
                          throw FormatException("Please enter a username!");
                        }
                        if (emailController.text == '') {
                          throw FormatException(
                              "Please enter an email address!");
                        }
                        if (passwordController.text == '') {
                          throw FormatException("Please enter a password!");
                        }
                        if (verifyPasswordController.text == '') {
                          throw FormatException(
                              "Please verify the password that you entered!");
                        }
                        isLoading = true;
                        trySignupUser(
                                usernameController.text,
                                emailController.text,
                                passwordController.text,
                                verifyPasswordController.text)
                            .then(
                          (String? returnValue) {
                            isLoading = false;
                            if (returnValue != null) {
                              fToast.showToast(
                                child: returnToast(returnValue, false),
                                toastDuration: Duration(seconds: 5),
                                gravity: ToastGravity.BOTTOM,
                              );
                            } else {
                              fToast.showToast(
                                child: returnToast(
                                    "Successfully created your account!", true),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 5),
                              );
                              setState(() {
                                cardView = "Login";
                              });
                            }
                          },
                        );
                      } catch (e) {
                        fToast.showToast(
                          child: returnToast(e.toString(), false),
                          toastDuration: Duration(seconds: 5),
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Row(children: [
                      FaIcon(FontAwesomeIcons.arrowLeft),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Return to login"),
                      ),
                    ]),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                    ),
                    onPressed: () {
                      setState(() {
                        cardView = "Login";
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage(
                        'assets/logo/icon.png',
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: checkCardView(),
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading: isLoading,
      ),
    );
  }

  Widget returnToast(String text, bool success) {
    Widget toast = Text("");
    if (success) {
      toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.green,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.check),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      );
    } else {
      toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.red,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.exclamation),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      );
    }
    return toast;
  }
}

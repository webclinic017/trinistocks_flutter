import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trinistocks_flutter/apis/profile_management_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = true;
  String? username;
  String? email;
  String? token;
  late FToast fToast;
  String cardView = "Login";
  late Card profileCardView;
  late Card deleteConfirmCardView;
  TextEditingController deleteController = new TextEditingController(text: "");

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Widget checkCardView() {
    if (cardView == "Login") {
      return profileCardView;
    } else if (cardView == "Delete") {
      return deleteConfirmCardView;
    } else
      return profileCardView;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    profileCardView = Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 75,
            child: Stack(
              children: [
                // places the text field in the center of the stack widget
                Center(
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).backgroundColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "$username",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                // use a positioned widget to achive the custom label
                PositionedDirectional(
                  start: 120,
                  end: 120,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).splashColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          ' Username',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 75,
            child: Stack(
              children: [
                // places the text field in the center of the stack widget
                Center(
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).backgroundColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "$email",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                // use a positioned widget to achive the custom label
                PositionedDirectional(
                  start: 120,
                  end: 120,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).splashColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail,
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          ' Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  confirmDelete();
                },
                icon: FaIcon(
                  FontAwesomeIcons.trash,
                  size: 18,
                ),
                label: Text(
                  "Delete Account",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                ),
                onPressed: logout,
                icon: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  size: 18,
                ),
                label: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    deleteConfirmCardView = Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Container(
                width: 300,
                child: Text(
                  "Are you sure that you want to delete your account? Type DELETE to confirm.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            child: TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              controller: deleteController,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  deleteUser(token).then((returnMessage) {
                    if (returnMessage == null) {
                      fToast.showToast(
                        child: returnToast(
                            "Successfully deleted your account.", true),
                        toastDuration: Duration(seconds: 5),
                        gravity: ToastGravity.BOTTOM,
                      );
                      logout();
                    } else {
                      fToast.showToast(
                        child: returnToast(returnMessage, false),
                        toastDuration: Duration(seconds: 5),
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  });
                },
                icon: FaIcon(
                  FontAwesomeIcons.trash,
                  size: 18,
                ),
                label: Text(
                  "Confirm Deletion",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
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

  void fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
      token = prefs.getString('token');
      isLoading = false;
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('token');
    await prefs.remove('email');
    Navigator.pushReplacementNamed(context, '/');
  }

  void confirmDelete() {
    setState(() {
      cardView = "Delete";
    });
  }

  Future<String?> deleteUser(String? token) {
    return ProfileManagementAPI.deleteUser(token);
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

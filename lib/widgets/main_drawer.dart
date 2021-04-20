import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawer extends StatefulWidget {
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            child: DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.house,
              color: Theme.of(context).accentColor,
              size: 30.0,
            ),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ExpansionTile(
            title: Text("Summarized"),
            children: [
              ListTile(
                leading: Icon(
                  Icons.list_alt_rounded,
                  color: Theme.of(context).accentColor,
                  size: 30.0,
                ),
                title: Text('Listed Stocks'),
                onTap: () {
                  Navigator.pushNamed(context, '/listed_stocks');
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartLine,
                  color: Theme.of(context).accentColor,
                  size: 30.0,
                ),
                title: Text('Technical Analysis'),
                onTap: () {
                  Navigator.pushNamed(context, '/technical_analysis');
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Historical"),
          ), /*or any other widget you want to apply the theme to.*/
        ],
      ),
    );
  }
}

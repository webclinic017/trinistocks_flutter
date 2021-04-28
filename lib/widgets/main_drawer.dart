import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawer extends StatefulWidget {
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    double dropDownHeaderSize = 18;
    double itemHeaderSize = 16;
    double iconSize = 40;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            child: DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.house,
              color: Theme.of(context).accentColor,
              size: iconSize,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
                fontSize: itemHeaderSize,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ExpansionTile(
            title: Text(
              "Summarized",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
                fontSize: dropDownHeaderSize,
              ),
            ),
            children: [
              ListTile(
                leading: Icon(
                  Icons.list_alt_rounded,
                  color: Theme.of(context).accentColor,
                  size: iconSize,
                ),
                title: Text(
                  'Listed Stocks',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: itemHeaderSize,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/listed_stocks');
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartLine,
                  color: Theme.of(context).accentColor,
                  size: iconSize,
                ),
                title: Text(
                  'Technical Analysis',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: itemHeaderSize,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/technical_analysis');
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.bookReader,
                  color: Theme.of(context).accentColor,
                  size: iconSize,
                ),
                title: Text(
                  'Fundamental Analysis',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: itemHeaderSize,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/fundamental_analysis');
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              "Historical",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
                fontSize: dropDownHeaderSize,
              ),
            ),
            children: [
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartBar,
                  color: Theme.of(context).accentColor,
                  size: iconSize,
                ),
                title: Text(
                  'Stock Prices',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: itemHeaderSize,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/stock_price_history');
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.handHoldingUsd,
                  color: Theme.of(context).accentColor,
                  size: iconSize,
                ),
                title: Text(
                  'Dividends',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: itemHeaderSize,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/dividend_history');
                },
              ),
            ],
          ), /*or any other widget you want to apply the theme to.*/
        ],
      ),
    );
  }
}

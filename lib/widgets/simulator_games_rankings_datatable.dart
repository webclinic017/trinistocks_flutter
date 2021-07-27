import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class SimulatorGamesRankingsDataTable extends StatefulWidget {
  //constructor to ask for tabledata
  SimulatorGamesRankingsDataTable(
      {required this.tableData,
      required this.headerColor,
      required this.leftHandColor});

  List tableData;
  final Color headerColor;
  final Color leftHandColor;

  @override
  _SimulatorGamesRankingsDataTableState createState() =>
      _SimulatorGamesRankingsDataTableState();
}

class _SimulatorGamesRankingsDataTableState
    extends State<SimulatorGamesRankingsDataTable> {
  int symbolSort = 0;
  int valueTradedSort = -1;

  @override
  void initState() {
    super.initState();
  }

  String checkValueTradedSort() {
    switch (valueTradedSort) {
      case 0:
        {
          return '';
        }
      case -1:
        {
          return '↓';
        }
      case 1:
        {
          return '↑';
        }
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    simulatorPlayers.initData(widget.tableData);
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 80,
        rightHandSideColumnWidth: 460,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.tableData.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 1.0,
        ),
        leftHandSideColBackgroundColor: widget.leftHandColor,
        rightHandSideColBackgroundColor: Theme.of(context).backgroundColor,
        enablePullToRefresh: false,
        elevation: 0.0,
      ),
      height: 53.0 * (widget.tableData.length + 1),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget("Rank", 80),
      _getTitleItemWidget("Username", 200),
      _getTitleItemWidget("Portfolio Value", 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.start,
      ),
      width: width,
      height: 50,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      color: widget.headerColor,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
        simulatorPlayers.simulatorPlayerData[index].currentPosition.toString(),
        style: TextStyle(color: Colors.black),
      ),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var compactFormat =
        NumberFormat.compactCurrency(locale: 'en_US', symbol: "\$");
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            simulatorPlayers.simulatorPlayerData[index].username,
            style: TextStyle(),
          ),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text(
                compactFormat.format(simulatorPlayers
                    .simulatorPlayerData[index].currentPortfolioValue),
                style: simulatorPlayers
                            .simulatorPlayerData[index].currentPortfolioValue >=
                        0
                    ? TextStyle(color: Colors.green)
                    : TextStyle(color: Colors.red),
              )
            ],
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

SimulatorPlayers simulatorPlayers = SimulatorPlayers();

class SimulatorPlayers {
  List<SimulatorPlayerData> simulatorPlayerData = [];

  void initData(List tableData) {
    for (int i = 0; i < tableData.length; i++) {
      simulatorPlayerData.add(
        SimulatorPlayerData(
          tableData[i]['current_position'],
          tableData[i]['username'],
          double.parse(tableData[i]['current_portfolio_value']),
        ),
      );
    }
  }
}

class SimulatorPlayerData {
  int currentPosition;
  String username;
  double currentPortfolioValue;

  SimulatorPlayerData(
    this.currentPosition,
    this.username,
    this.currentPortfolioValue,
  );
}

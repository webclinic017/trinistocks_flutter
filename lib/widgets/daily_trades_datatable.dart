import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class DailyTradesDataTable extends StatefulWidget {
  //constructor to ask for tabledata
  const DailyTradesDataTable({required this.tableData});

  final List<Map> tableData;

  @override
  _DailyTradesDataTableState createState() => _DailyTradesDataTableState();
}

class _DailyTradesDataTableState extends State<DailyTradesDataTable> {
  int symbolSort = 0;
  int valueTradedSort = -1;

  @override
  void initState() {
    dailyTrades.initData(widget.tableData);
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
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
        enablePullToRefresh: false,
      ),
      height: 52.0 * (widget.tableData.length + 1),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget("Symbol", 80),
      _getTitleItemWidget("Change", 80),
      _getTitleItemWidget("Open Price", 80),
      _getTitleItemWidget("Low", 60),
      _getTitleItemWidget("High", 60),
      _getTitleItemWidget("Close Price", 80),
      _getTitleItemWidget("Value Traded " + checkValueTradedSort(), 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
      ),
      width: width,
      height: 50,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      color: Colors.grey[500],
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(dailyTrades.dailyTradeData[index].symbol),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      color: Colors.grey[300],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var compactFormat =
        NumberFormat.compactCurrency(locale: 'en_US', symbol: "\$");
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text(compactFormat
                  .format(dailyTrades.dailyTradeData[index].changeDollars))
            ],
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            compactFormat.format(dailyTrades.dailyTradeData[index].openPrice),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            compactFormat.format(dailyTrades.dailyTradeData[index].low),
          ),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            compactFormat.format(dailyTrades.dailyTradeData[index].high),
          ),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            compactFormat.format(dailyTrades.dailyTradeData[index].closePrice),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            compactFormat.format(dailyTrades.dailyTradeData[index].valueTraded),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

DailyTrades dailyTrades = DailyTrades();

class DailyTrades {
  List<DailyTradeData> dailyTradeData = [];

  void initData(List<Map> tableData) {
    for (int i = 0; i < tableData.length; i++) {
      dailyTradeData.add(DailyTradeData(
          tableData[i]['symbol'],
          tableData[i]['date'],
          tableData[i]['value_traded'],
          tableData[i]['volume_traded'],
          tableData[i]['open_price'],
          tableData[i]['close_price'],
          tableData[i]['change_dollars'],
          tableData[i]['high'],
          tableData[i]['low']));
    }
  }

  void sortSymbol(int symbolSort) {
    if (symbolSort == -1) {
      dailyTradeData.sort((a, b) => (a.symbol.compareTo(b.symbol)));
    } else {
      dailyTradeData.sort((a, b) => (b.symbol.compareTo(a.symbol)));
    }
  }

  void sortValueTraded(int valueTradedSort) {
    if (valueTradedSort == -1) {
      dailyTradeData.sort((a, b) => (a.valueTraded.compareTo(b.valueTraded)));
    } else {
      dailyTradeData.sort((a, b) => (b.valueTraded.compareTo(a.valueTraded)));
    }
  }
}

class DailyTradeData {
  String symbol;
  DateTime date;
  double valueTraded;
  int volumeTraded;
  double openPrice;
  double closePrice;
  double changeDollars;
  double high;
  double low;

  DailyTradeData(this.symbol, this.date, this.valueTraded, this.volumeTraded,
      this.openPrice, this.closePrice, this.changeDollars, this.high, this.low);
}

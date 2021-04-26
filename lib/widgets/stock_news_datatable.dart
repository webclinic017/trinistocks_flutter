import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class StockNewsDataTable extends StatefulWidget {
  //constructor to ask for tabledata
  const StockNewsDataTable(
      {required this.tableData,
      required this.headerColor,
      required this.leftHandColor});

  final List<Map> tableData;
  final Color headerColor;
  final Color leftHandColor;

  @override
  _StockNewsDataTableState createState() => _StockNewsDataTableState();
}

class _StockNewsDataTableState extends State<StockNewsDataTable> {
  int symbolSort = 0;
  int dateSort = -1;

  @override
  void initState() {
    stockNews.initData(widget.tableData);
    super.initState();
  }

  String checkDateSort() {
    switch (dateSort) {
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
        rightHandSideColumnWidth: 500,
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
      ),
      height: 53.0 * (widget.tableData.length + 1),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget("Symbol", 80),
      _getTitleItemWidget("Date" + checkDateSort(), 100),
      _getTitleItemWidget("Title", 300),
      _getTitleItemWidget("Category", 100),
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
        stockNews.stockNewsData[index].symbol,
        style: TextStyle(color: Colors.black),
      ),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var formatter = new DateFormat.yMMMMd('en_US');
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text(
                formatter.format(stockNews.stockNewsData[index].date),
                style: TextStyle(color: Theme.of(context).accentColor),
              )
            ],
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: new InkWell(
            child: new Text(stockNews.stockNewsData[index].title,
                style: TextStyle(color: Theme.of(context).accentColor)),
            onTap: () => launch(widget.tableData[index]["link"]),
          ),
          width: 300,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(stockNews.stockNewsData[index].category,
              style: TextStyle(color: Theme.of(context).accentColor)),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

StockNews stockNews = StockNews();

class StockNews {
  List<StockNewsData> stockNewsData = [];

  void initData(List<Map> tableData) {
    for (int i = 0; i < tableData.length; i++) {
      stockNewsData.add(StockNewsData(
          tableData[i]['symbol'],
          tableData[i]['date'],
          tableData[i]['category'],
          tableData[i]['title']));
    }
  }

  void sortSymbol(int symbolSort) {
    if (symbolSort == -1) {
      stockNewsData.sort((a, b) => (a.symbol.compareTo(b.symbol)));
    } else {
      stockNewsData.sort((a, b) => (b.symbol.compareTo(a.symbol)));
    }
  }

  void sortDate(int dateSort) {
    if (dateSort == -1) {
      stockNewsData.sort((a, b) => (a.date.compareTo(b.date)));
    } else {
      stockNewsData.sort((a, b) => (b.date.compareTo(a.date)));
    }
  }
}

class StockNewsData {
  String symbol;
  String category;
  DateTime date;
  String title;

  StockNewsData(this.symbol, this.date, this.category, this.title);
}

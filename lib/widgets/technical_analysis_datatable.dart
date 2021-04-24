import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class TechnicalAnalysisDataTable extends StatefulWidget {
  //constructor to ask for tabledata
  const TechnicalAnalysisDataTable(
      {required this.tableData,
      required this.headerColor,
      required this.leftHandColor});

  final List<Map> tableData;
  final Color headerColor;
  final Color leftHandColor;

  @override
  _TechnicalAnalysisDataTableState createState() =>
      _TechnicalAnalysisDataTableState();
}

class _TechnicalAnalysisDataTableState
    extends State<TechnicalAnalysisDataTable> {
  //set up the sorts which keep track of what header is being used for sorting
  // 0 means not used, -1 means descending and 1 means ascending
  int symbolSort = -1;
  int latestClosePriceSort = 0;
  int high52WSort = 0;
  int low52WSort = 0;
  int ytdSort = 0;
  int mtdSort = 0;
  int wtdSort = 0;
  int betaSort = 0;
  int adtvSort = 0;
  TechnicalAnalysis technicalAnalysis = TechnicalAnalysis();

  @override
  void initState() {
    technicalAnalysis.initData(widget.tableData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 80,
        rightHandSideColumnWidth: 750,
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
      height: 52.0 * (widget.tableData.length + 1),
    );
  }

  void changeSymbolSort() {
    switch (symbolSort) {
      case -1:
        {
          symbolSort = 1;
          break;
        }
      case 0:
        {
          symbolSort = 1;
          break;
        }
      case 1:
        {
          symbolSort = -1;
          break;
        }
    }
  }

  String checkSymbolSort() {
    switch (symbolSort) {
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

  void changeLatestClosePriceSort() {
    switch (latestClosePriceSort) {
      case -1:
        {
          latestClosePriceSort = 1;
          break;
        }
      case 0:
        {
          latestClosePriceSort = 1;
          break;
        }
      case 1:
        {
          latestClosePriceSort = -1;
          break;
        }
    }
  }

  String checkLatestClosePriceSort() {
    switch (latestClosePriceSort) {
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

  void change52WHighSort() {
    switch (high52WSort) {
      case -1:
        {
          high52WSort = 1;
          break;
        }
      case 0:
        {
          high52WSort = 1;
          break;
        }
      case 1:
        {
          high52WSort = -1;
          break;
        }
    }
  }

  String check52WHighSort() {
    switch (high52WSort) {
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

  void change52WLowSort() {
    switch (low52WSort) {
      case -1:
        {
          low52WSort = 1;
          break;
        }
      case 0:
        {
          low52WSort = 1;
          break;
        }
      case 1:
        {
          low52WSort = -1;
          break;
        }
    }
  }

  String check52WLowSort() {
    switch (low52WSort) {
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

  void changeYTDSort() {
    switch (ytdSort) {
      case -1:
        {
          ytdSort = 1;
          break;
        }
      case 0:
        {
          ytdSort = 1;
          break;
        }
      case 1:
        {
          ytdSort = -1;
          break;
        }
    }
  }

  String checkYTDSort() {
    switch (ytdSort) {
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

  void changeMTDSort() {
    switch (mtdSort) {
      case -1:
        {
          mtdSort = 1;
          break;
        }
      case 0:
        {
          mtdSort = 1;
          break;
        }
      case 1:
        {
          mtdSort = -1;
          break;
        }
    }
  }

  String checkMTDSort() {
    switch (mtdSort) {
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

  void changeWTDSort() {
    switch (wtdSort) {
      case -1:
        {
          wtdSort = 1;
          break;
        }
      case 0:
        {
          wtdSort = 1;
          break;
        }
      case 1:
        {
          wtdSort = -1;
          break;
        }
    }
  }

  String checkWTDSort() {
    switch (wtdSort) {
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

  void changeBetaSort() {
    switch (betaSort) {
      case -1:
        {
          betaSort = 1;
          break;
        }
      case 0:
        {
          betaSort = 1;
          break;
        }
      case 1:
        {
          betaSort = -1;
          break;
        }
    }
  }

  String checkBetaSort() {
    switch (betaSort) {
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

  void changeADTVSort() {
    switch (adtvSort) {
      case -1:
        {
          adtvSort = 1;
          break;
        }
      case 0:
        {
          adtvSort = 1;
          break;
        }
      case 1:
        {
          adtvSort = -1;
          break;
        }
    }
  }

  String checkADTVSort() {
    switch (adtvSort) {
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

  List<Widget> _getTitleWidget() {
    ButtonStyle titleButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      side: BorderSide(width: 0, style: BorderStyle.none),
      padding: EdgeInsets.zero,
      primary: Theme.of(context).accentColor,
    );
    return [
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("Symbol" + checkSymbolSort(), 90),
        onPressed: () {
          changeSymbolSort();
          technicalAnalysis.sortSymbol(symbolSort);
          latestClosePriceSort = 0;
          high52WSort = 0;
          low52WSort = 0;
          ytdSort = 0;
          mtdSort = 0;
          wtdSort = 0;
          betaSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      _getTitleItemWidget("SMA200", 70),
      _getTitleItemWidget("SMA20", 60),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget(
            "Last Close Price" + checkLatestClosePriceSort(), 80),
        onPressed: () {
          changeLatestClosePriceSort();
          technicalAnalysis.sortLatestClosePrice(latestClosePriceSort);
          symbolSort = 0;
          high52WSort = 0;
          low52WSort = 0;
          ytdSort = 0;
          mtdSort = 0;
          wtdSort = 0;
          betaSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("52W High" + check52WHighSort(), 80),
        onPressed: () {
          change52WHighSort();
          technicalAnalysis.sort52WHigh(high52WSort);
          symbolSort = 0;
          latestClosePriceSort = 0;
          low52WSort = 0;
          ytdSort = 0;
          mtdSort = 0;
          wtdSort = 0;
          betaSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("52W Low" + check52WLowSort(), 80),
        onPressed: () {
          change52WLowSort();
          technicalAnalysis.sort52WLow(low52WSort);
          symbolSort = 0;
          latestClosePriceSort = 0;
          high52WSort = 0;
          ytdSort = 0;
          mtdSort = 0;
          wtdSort = 0;
          betaSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("YTD" + checkYTDSort(), 70),
        onPressed: () {
          changeYTDSort();
          technicalAnalysis.sortYTD(ytdSort);
          symbolSort = 0;
          latestClosePriceSort = 0;
          high52WSort = 0;
          low52WSort = 0;
          mtdSort = 0;
          wtdSort = 0;
          betaSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("MTD" + checkMTDSort(), 70),
        onPressed: () {
          changeMTDSort();
          technicalAnalysis.sortMTD(mtdSort);
          symbolSort = 0;
          latestClosePriceSort = 0;
          high52WSort = 0;
          low52WSort = 0;
          ytdSort = 0;
          wtdSort = 0;
          betaSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("WTD" + checkWTDSort(), 70),
        onPressed: () {
          changeWTDSort();
          technicalAnalysis.sortWTD(wtdSort);
          symbolSort = 0;
          latestClosePriceSort = 0;
          high52WSort = 0;
          low52WSort = 0;
          mtdSort = 0;
          ytdSort = 0;
          betaSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("Beta" + checkBetaSort(), 80),
        onPressed: () {
          changeBetaSort();
          technicalAnalysis.sortBeta(betaSort);
          symbolSort = 0;
          latestClosePriceSort = 0;
          high52WSort = 0;
          low52WSort = 0;
          mtdSort = 0;
          wtdSort = 0;
          ytdSort = 0;
          adtvSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("ADTV" + checkADTVSort(), 90),
        onPressed: () {
          changeADTVSort();
          technicalAnalysis.sortADTV(adtvSort);
          symbolSort = 0;
          latestClosePriceSort = 0;
          high52WSort = 0;
          low52WSort = 0;
          mtdSort = 0;
          wtdSort = 0;
          betaSort = 0;
          ytdSort = 0;
          setState(() {});
        },
      ),
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
        technicalAnalysis.technicalAnalysisData[index].symbol,
        style: TextStyle(color: Colors.black),
      ),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var dollarFormat = NumberFormat('0.00', 'en-US');
    var compactFormat = NumberFormat.compact();
    return Row(
      children: <Widget>[
        Container(
          child: Text(
              '\$${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].sma200)}'),
          width: 70,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '\$${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].sma20)}'),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '\$${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].latestClosePrice)}'),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '\$${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].high52w)}'),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '\$${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].low52w)}'),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            '${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].ytd)}%',
            style: technicalAnalysis.technicalAnalysisData[index].ytd >= 0
                ? TextStyle(color: Colors.green)
                : TextStyle(color: Colors.red),
          ),
          width: 70,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            '${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].mtd)}%',
            style: technicalAnalysis.technicalAnalysisData[index].mtd >= 0
                ? TextStyle(color: Colors.green)
                : TextStyle(color: Colors.red),
          ),
          width: 70,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            '${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].wtd)}%',
            style: technicalAnalysis.technicalAnalysisData[index].wtd >= 0
                ? TextStyle(color: Colors.green)
                : TextStyle(color: Colors.red),
          ),
          width: 70,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '${dollarFormat.format(technicalAnalysis.technicalAnalysisData[index].beta)}'),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '${compactFormat.format(technicalAnalysis.technicalAnalysisData[index].adtv)} shares'),
          width: 90,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

class TechnicalAnalysis {
  List<TechnicalAnalysisData> technicalAnalysisData = [];

  void initData(List<Map> tableData) {
    for (int i = 0; i < tableData.length; i++) {
      TechnicalAnalysisData stockData = TechnicalAnalysisData(
          tableData[i]['symbol'],
          tableData[i]['sma_200'],
          tableData[i]['sma_20'],
          tableData[i]['last_close_price'],
          tableData[i]['high_52w'],
          tableData[i]['low_52w'],
          tableData[i]['ytd'],
          tableData[i]['mtd'],
          tableData[i]['wtd'],
          tableData[i]['beta'],
          tableData[i]['adtv']);
      technicalAnalysisData.add(stockData);
    }
  }

  //Sort dataset on click
  void sortSymbol(int symbolSort) {
    if (symbolSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.symbol.compareTo(b.symbol)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.symbol.compareTo(a.symbol)));
    }
  }

  void sortLatestClosePrice(int latestClosePriceSort) {
    if (latestClosePriceSort == -1) {
      technicalAnalysisData
          .sort((a, b) => (a.latestClosePrice.compareTo(b.latestClosePrice)));
    } else {
      technicalAnalysisData
          .sort((a, b) => (b.latestClosePrice.compareTo(a.latestClosePrice)));
    }
  }

  void sort52WHigh(int high52WSort) {
    if (high52WSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.high52w.compareTo(b.high52w)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.high52w.compareTo(a.high52w)));
    }
  }

  void sort52WLow(int low52WSort) {
    if (low52WSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.low52w.compareTo(b.low52w)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.low52w.compareTo(a.low52w)));
    }
  }

  void sortYTD(int ytdSort) {
    if (ytdSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.ytd.compareTo(b.ytd)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.ytd.compareTo(a.ytd)));
    }
  }

  void sortMTD(int mtdSort) {
    if (mtdSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.mtd.compareTo(b.mtd)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.mtd.compareTo(a.mtd)));
    }
  }

  void sortWTD(int wtdSort) {
    if (wtdSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.wtd.compareTo(b.wtd)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.wtd.compareTo(a.wtd)));
    }
  }

  void sortBeta(int betaSort) {
    if (betaSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.beta.compareTo(b.beta)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.beta.compareTo(a.beta)));
    }
  }

  void sortADTV(int adtvSort) {
    if (adtvSort == -1) {
      technicalAnalysisData.sort((a, b) => (a.adtv.compareTo(b.adtv)));
    } else {
      technicalAnalysisData.sort((a, b) => (b.adtv.compareTo(a.adtv)));
    }
  }
}

class TechnicalAnalysisData {
  String symbol;
  double sma200;
  double sma20;
  double latestClosePrice;
  double high52w;
  double low52w;
  double ytd;
  double mtd;
  double wtd;
  double beta;
  int adtv;

  TechnicalAnalysisData(
      this.symbol,
      this.sma200,
      this.sma20,
      this.latestClosePrice,
      this.high52w,
      this.low52w,
      this.ytd,
      this.mtd,
      this.wtd,
      this.beta,
      this.adtv);
}

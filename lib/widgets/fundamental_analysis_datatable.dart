import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class FundamentalAnalysisDataTable extends StatefulWidget {
  //constructor to ask for tabledata
  FundamentalAnalysisDataTable(
      {required this.tableData,
      required this.headerColor,
      required this.leftHandColor});

  final List<Map> tableData;
  final Color headerColor;
  final Color leftHandColor;

  @override
  _FundamentalAnalysisDataTableState createState() =>
      _FundamentalAnalysisDataTableState();
}

class _FundamentalAnalysisDataTableState
    extends State<FundamentalAnalysisDataTable> {
  //set up the sorts which keep track of what header is being used for sorting
  // 0 means not used, -1 means descending and 1 means ascending
  int symbolSort = -1;
  int sectorSort = 0;
  int priceToEarningsSort = 0;
  int returnOnEquitySort = 0;
  int priceToBookSort = 0;
  int currentRatioSort = 0;
  int dividendYieldSort = 0;
  int payoutRatioSort = 0;
  int cashPerShareSort = 0;
  FundamentalAnalysis fundamentalAnalysis = new FundamentalAnalysis();

  @override
  void initState() {
    fundamentalAnalysis.initData(widget.tableData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 80,
        rightHandSideColumnWidth: 560,
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
      height: 50.0 * (widget.tableData.length + 1),
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

  void changeSectorSort() {
    switch (sectorSort) {
      case -1:
        {
          sectorSort = 1;
          break;
        }
      case 0:
        {
          sectorSort = 1;
          break;
        }
      case 1:
        {
          sectorSort = -1;
          break;
        }
    }
  }

  String checkSectorSort() {
    switch (sectorSort) {
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

  void changePriceToEarningsSort() {
    switch (priceToEarningsSort) {
      case -1:
        {
          priceToEarningsSort = 1;
          break;
        }
      case 0:
        {
          priceToEarningsSort = 1;
          break;
        }
      case 1:
        {
          priceToEarningsSort = -1;
          break;
        }
    }
  }

  String checkPriceToEarningsSort() {
    switch (priceToEarningsSort) {
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

  void changeReturnOnEquitySort() {
    switch (returnOnEquitySort) {
      case -1:
        {
          returnOnEquitySort = 1;
          break;
        }
      case 0:
        {
          returnOnEquitySort = 1;
          break;
        }
      case 1:
        {
          returnOnEquitySort = -1;
          break;
        }
    }
  }

  String checkReturnOnEquitySort() {
    switch (returnOnEquitySort) {
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

  void changepriceToBookSort() {
    switch (priceToBookSort) {
      case -1:
        {
          priceToBookSort = 1;
          break;
        }
      case 0:
        {
          priceToBookSort = 1;
          break;
        }
      case 1:
        {
          priceToBookSort = -1;
          break;
        }
    }
  }

  String checkpriceToBookSort() {
    switch (priceToBookSort) {
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

  void changeCurrentRatioSort() {
    switch (currentRatioSort) {
      case -1:
        {
          currentRatioSort = 1;
          break;
        }
      case 0:
        {
          currentRatioSort = 1;
          break;
        }
      case 1:
        {
          currentRatioSort = -1;
          break;
        }
    }
  }

  String checkCurrentRatioSort() {
    switch (currentRatioSort) {
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

  void changeDividendYieldSort() {
    switch (dividendYieldSort) {
      case -1:
        {
          dividendYieldSort = 1;
          break;
        }
      case 0:
        {
          dividendYieldSort = 1;
          break;
        }
      case 1:
        {
          dividendYieldSort = -1;
          break;
        }
    }
  }

  String checkdDividendYieldSort() {
    switch (dividendYieldSort) {
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

  void changePayoutRatioSort() {
    switch (payoutRatioSort) {
      case -1:
        {
          payoutRatioSort = 1;
          break;
        }
      case 0:
        {
          payoutRatioSort = 1;
          break;
        }
      case 1:
        {
          payoutRatioSort = -1;
          break;
        }
    }
  }

  String checkPayoutRatioSort() {
    switch (payoutRatioSort) {
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

  void changeCashPerShareSort() {
    switch (cashPerShareSort) {
      case -1:
        {
          cashPerShareSort = 1;
          break;
        }
      case 0:
        {
          cashPerShareSort = 1;
          break;
        }
      case 1:
        {
          cashPerShareSort = -1;
          break;
        }
    }
  }

  String checkCashPerShareSort() {
    switch (cashPerShareSort) {
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
      primary: Colors.black,
    );
    return [
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("Symbol" + checkSymbolSort(), 90),
        onPressed: () {
          changeSymbolSort();
          fundamentalAnalysis.sortSymbol(symbolSort);
          sectorSort = 0;
          priceToEarningsSort = 0;
          returnOnEquitySort = 0;
          priceToBookSort = 0;
          currentRatioSort = 0;
          dividendYieldSort = 0;
          payoutRatioSort = 0;
          cashPerShareSort = 0;
          setState(() {});
        },
      ),
      _getTitleItemWidget("P/E", 60),
      _getTitleItemWidget("RoE", 60),
      _getTitleItemWidget("P/B", 60),
      _getTitleItemWidget("Current Ratio", 60),
      _getTitleItemWidget("Dividend Yield", 60),
      _getTitleItemWidget("Payout Ratio", 60),
      _getTitleItemWidget("Cash Per Share", 60),
      _getTitleItemWidget("Last Updated", 130),
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
        fundamentalAnalysis.fundamentalAnalysisData[index].symbol,
        style: TextStyle(color: Colors.black),
      ),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      color: widget.leftHandColor,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var decimalFormat = NumberFormat('##0.00', 'en-US');
    var dateFormatter = new DateFormat.yMMMMd('en_US');
    return Row(
      children: <Widget>[
        Container(
          child: Text(decimalFormat.format(fundamentalAnalysis
              .fundamentalAnalysisData[index].priceToEarningsRatio)),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(decimalFormat.format(fundamentalAnalysis
              .fundamentalAnalysisData[index].returnOnEquity)),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(decimalFormat.format(fundamentalAnalysis
              .fundamentalAnalysisData[index].priceToBookRatio)),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(decimalFormat.format(
              fundamentalAnalysis.fundamentalAnalysisData[index].currentRatio)),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(decimalFormat.format(fundamentalAnalysis
                  .fundamentalAnalysisData[index].dividendYield) +
              "%"),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(decimalFormat.format(fundamentalAnalysis
              .fundamentalAnalysisData[index].dividendPayoutRatio)),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(decimalFormat.format(
              fundamentalAnalysis.fundamentalAnalysisData[index].cashPerShare)),
          width: 60,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(dateFormatter
              .format(fundamentalAnalysis.fundamentalAnalysisData[index].date)),
          width: 140,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

class FundamentalAnalysis {
  List<FundamentalAnalysisData> fundamentalAnalysisData = [];

  void initData(List<Map> tableData) {
    for (int i = 0; i < tableData.length; i++) {
      FundamentalAnalysisData stockData = FundamentalAnalysisData(
          tableData[i]['symbol'],
          tableData[i]['sector'],
          tableData[i]['date'],
          tableData[i]['report_type'],
          tableData[i]['RoE'],
          tableData[i]['EPS'],
          tableData[i]['RoIC'],
          tableData[i]['current_ratio'],
          tableData[i]['price_to_earnings_ratio'],
          tableData[i]['dividend_yield'],
          tableData[i]['dividend_payout_ratio'],
          tableData[i]['price_to_book_ratio'],
          tableData[i]['cash_per_share']);
      fundamentalAnalysisData.add(stockData);
    }
  }

  //Sort dataset on click
  void sortSymbol(int symbolSort) {
    if (symbolSort == -1) {
      fundamentalAnalysisData.sort((a, b) => (a.symbol.compareTo(b.symbol)));
    } else {
      fundamentalAnalysisData.sort((a, b) => (b.symbol.compareTo(a.symbol)));
    }
  }

  void sortSector(int sectorSort) {
    if (sectorSort == -1) {
      fundamentalAnalysisData.sort((a, b) => (a.sector.compareTo(b.sector)));
    } else {
      fundamentalAnalysisData.sort((a, b) => (b.sector.compareTo(a.sector)));
    }
  }

  void sortPricetoEarningsSector(int priceToEarningsSort) {
    if (priceToEarningsSort == -1) {
      fundamentalAnalysisData.sort(
          (a, b) => (a.priceToEarningsRatio.compareTo(b.priceToEarningsRatio)));
    } else {
      fundamentalAnalysisData.sort(
          (a, b) => (b.priceToEarningsRatio.compareTo(a.priceToEarningsRatio)));
    }
  }

  void sortReturnOnEquitySort(int returnOnEquitySort) {
    if (returnOnEquitySort == -1) {
      fundamentalAnalysisData
          .sort((a, b) => (a.returnOnEquity.compareTo(b.returnOnEquity)));
    } else {
      fundamentalAnalysisData
          .sort((a, b) => (b.returnOnEquity.compareTo(a.returnOnEquity)));
    }
  }

  void sortPriceToBookSort(int priceToBookSort) {
    if (priceToBookSort == -1) {
      fundamentalAnalysisData
          .sort((a, b) => (a.priceToBookRatio.compareTo(b.priceToBookRatio)));
    } else {
      fundamentalAnalysisData
          .sort((a, b) => (b.priceToBookRatio.compareTo(a.priceToBookRatio)));
    }
  }

  void sortCurrentRatio(int currentRatioSort) {
    if (currentRatioSort == -1) {
      fundamentalAnalysisData
          .sort((a, b) => (a.currentRatio.compareTo(b.currentRatio)));
    } else {
      fundamentalAnalysisData
          .sort((a, b) => (b.currentRatio.compareTo(a.currentRatio)));
    }
  }

  void sortDividendYield(int dividendYieldSort) {
    if (dividendYieldSort == -1) {
      fundamentalAnalysisData
          .sort((a, b) => (a.dividendYield.compareTo(b.dividendYield)));
    } else {
      fundamentalAnalysisData
          .sort((a, b) => (b.dividendYield.compareTo(a.dividendYield)));
    }
  }
}

class FundamentalAnalysisData {
  String symbol;
  String sector;
  DateTime date;
  String reportType;
  double returnOnEquity;
  double earningsPerShare;
  double returnOnInvestedCapital;
  double currentRatio;
  double priceToEarningsRatio;
  double dividendYield;
  double dividendPayoutRatio;
  double priceToBookRatio;
  double cashPerShare;

  FundamentalAnalysisData(
      this.symbol,
      this.sector,
      this.date,
      this.reportType,
      this.returnOnEquity,
      this.earningsPerShare,
      this.returnOnInvestedCapital,
      this.currentRatio,
      this.priceToEarningsRatio,
      this.dividendYield,
      this.dividendPayoutRatio,
      this.priceToBookRatio,
      this.cashPerShare);
}

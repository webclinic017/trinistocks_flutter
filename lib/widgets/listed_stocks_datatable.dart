import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class ListedStocksDataTable extends StatefulWidget {
  //constructor to ask for tabledata
  const ListedStocksDataTable({required this.tableData});

  final List<Map> tableData;

  @override
  _ListedStocksDataTableState createState() => _ListedStocksDataTableState();
}

class _ListedStocksDataTableState extends State<ListedStocksDataTable> {
  //set up the sorts which keep track of what header is being used for sorting
  // 0 means not used, -1 means descending and 1 means ascending
  int symbolSort = 0;
  int securityNameSort = 0;
  int statusSort = 0;
  int sectorSort = 0;
  int issuedShareCapitalSort = 0;
  int marketCapitalizationSort = -1;
  int financialYearEndSort = 0;
  int currencySort = 0;

  @override
  void initState() {
    listedStock.initData(widget.tableData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 80,
        rightHandSideColumnWidth: 870,
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

  void changeIssuedShareCapitalSort() {
    switch (issuedShareCapitalSort) {
      case -1:
        {
          issuedShareCapitalSort = 1;
          break;
        }
      case 0:
        {
          issuedShareCapitalSort = 1;
          break;
        }
      case 1:
        {
          issuedShareCapitalSort = -1;
          break;
        }
    }
  }

  String checkIssuedShareCapitalSort() {
    switch (issuedShareCapitalSort) {
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

  void changeMarketCapitalSort() {
    switch (marketCapitalizationSort) {
      case -1:
        {
          marketCapitalizationSort = 1;
          break;
        }
      case 0:
        {
          marketCapitalizationSort = 1;
          break;
        }
      case 1:
        {
          marketCapitalizationSort = -1;
          break;
        }
    }
  }

  String checkMarketCapitalSort() {
    switch (marketCapitalizationSort) {
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
        child: _getTitleItemWidget("Symbol" + checkSymbolSort(), 100),
        onPressed: () {
          changeSymbolSort();
          listedStock.sortSymbol(symbolSort);
          sectorSort = 0;
          issuedShareCapitalSort = 0;
          marketCapitalizationSort = 0;
          setState(() {});
        },
      ),
      _getTitleItemWidget("Security Name", 250),
      _getTitleItemWidget("Status", 100),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget("Sector" + checkSectorSort(), 120),
        onPressed: () {
          changeSectorSort();
          listedStock.sortSector(sectorSort);
          symbolSort = 0;
          issuedShareCapitalSort = 0;
          marketCapitalizationSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget(
            "Issued Share Capital" + checkIssuedShareCapitalSort(), 120),
        onPressed: () {
          changeIssuedShareCapitalSort();
          listedStock.sortIssuedShareCapitalization(issuedShareCapitalSort);
          symbolSort = 0;
          sectorSort = 0;
          marketCapitalizationSort = 0;
          setState(() {});
        },
      ),
      TextButton(
        style: titleButtonStyle,
        child: _getTitleItemWidget(
            "Market Capitalization" + checkMarketCapitalSort(), 100),
        onPressed: () {
          changeMarketCapitalSort();
          listedStock.sortMarketCapitalization(marketCapitalizationSort);
          symbolSort = 0;
          sectorSort = 0;
          issuedShareCapitalSort = 0;
          setState(() {});
        },
      ),
      _getTitleItemWidget("Financial Year End", 100),
      _getTitleItemWidget("Currency", 80),
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
      child: Text(listedStock.listedStockData[index].symbol),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      color: Colors.grey[300],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var compactFormat = NumberFormat.compact();
    return Row(
      children: <Widget>[
        Container(
          child: Text(listedStock.listedStockData[index].securityName),
          width: 250,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(listedStock.listedStockData[index].status),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(listedStock.listedStockData[index].sector),
          width: 120,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '${compactFormat.format(listedStock.listedStockData[index].issuedShareCapital)} shares'),
          width: 120,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
              '\$${compactFormat.format(listedStock.listedStockData[index].marketCapitalization)}'),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(listedStock.listedStockData[index].financialYearEnd),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(listedStock.listedStockData[index].currency),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

ListedStock listedStock = ListedStock();

class ListedStock {
  List<ListedStockData> listedStockData = [];

  void initData(List<Map> tableData) {
    for (int i = 0; i < tableData.length; i++) {
      ListedStockData stockData = ListedStockData(
          tableData[i]['symbol'],
          tableData[i]['security_name'],
          tableData[i]['status'],
          tableData[i]['sector'],
          tableData[i]['issued_share_capital'],
          tableData[i]['market_capitalization'],
          tableData[i]['financial_year_end'],
          tableData[i]['currency']);
      listedStockData.add(stockData);
    }
  }

  //Sort dataset on click
  void sortSymbol(int symbolSort) {
    if (symbolSort == -1) {
      listedStockData.sort((a, b) => (a.symbol.compareTo(b.symbol)));
    } else {
      listedStockData.sort((a, b) => (b.symbol.compareTo(a.symbol)));
    }
  }

  void sortSector(int sectorSort) {
    if (sectorSort == -1) {
      listedStockData.sort((a, b) => (a.sector.compareTo(b.sector)));
    } else {
      listedStockData.sort((a, b) => (b.sector.compareTo(a.sector)));
    }
  }

  void sortIssuedShareCapitalization(int issuedShareCapitalizationSort) {
    if (issuedShareCapitalizationSort == -1) {
      listedStockData.sort(
          (a, b) => (a.issuedShareCapital.compareTo(b.issuedShareCapital)));
    } else {
      listedStockData.sort(
          (a, b) => (b.issuedShareCapital.compareTo(a.issuedShareCapital)));
    }
  }

  void sortMarketCapitalization(int marketCapitalizationSort) {
    if (marketCapitalizationSort == -1) {
      listedStockData.sort(
          (a, b) => (a.marketCapitalization.compareTo(b.marketCapitalization)));
    } else {
      listedStockData.sort(
          (a, b) => (b.marketCapitalization.compareTo(a.marketCapitalization)));
    }
  }
}

class ListedStockData {
  String symbol;
  String securityName;
  String status;
  String sector;
  int issuedShareCapital;
  double marketCapitalization;
  String financialYearEnd;
  String currency;

  ListedStockData(
      this.symbol,
      this.securityName,
      this.status,
      this.sector,
      this.issuedShareCapital,
      this.marketCapitalization,
      this.financialYearEnd,
      this.currency);
}

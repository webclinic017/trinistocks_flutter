import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class StockNewsPaginatedDataTable extends StatefulWidget {
  final List<Map> tableData;
  final DataTableSource sourceData = new StockNewsDataSource();
  //constructor to ask for tabledata
  StockNewsPaginatedDataTable(
    this.tableData,
  );

  @override
  _StockNewsPaginatedDataTableState createState() =>
      _StockNewsPaginatedDataTableState();
}

class _StockNewsPaginatedDataTableState
    extends State<StockNewsPaginatedDataTable> {
  int symbolSort = 0;
  int dateSort = -1;

  @override
  void initState() {
    super.initState();
  }

  List<DataColumn> buildTableColumns() {
    List<DataColumn> columns = <DataColumn>[
      DataColumn(
        label: Text('Date Published'),
      ),
      DataColumn(
        label: Text('Title'),
      ),
      DataColumn(
        label: Text('Category'),
      ),
    ];
    return columns;
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
    stockNews.initData(widget.tableData);
    return PaginatedDataTable(
      columns: buildTableColumns(),
      source: widget.sourceData,
    );
  }
}

class StockNewsDataSource extends DataTableSource {
  @override
  DataRow getRow(int index) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    final newsItem = stockNews.stockNewsData[index];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${dateFormat.format(newsItem.date)}')),
        DataCell(
          InkWell(
            child: new Text(stockNews.stockNewsData[index].title),
            onTap: () => launch(newsItem.link),
          ),
        ),
        DataCell(Text('${newsItem.category}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => stockNews.stockNewsData.length;

  @override
  int get selectedRowCount => 0;
}

StockNews stockNews = StockNews();

class StockNews {
  List<StockNewsData> stockNewsData = [];

  void initData(List<Map> tableData) {
    stockNewsData = [];
    for (int i = 0; i < tableData.length; i++) {
      stockNewsData.add(
        StockNewsData(
          tableData[i]['symbol'],
          tableData[i]['date'],
          tableData[i]['category'],
          tableData[i]['title'],
          tableData[i]['link'],
        ),
      );
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
  String link;

  StockNewsData(this.symbol, this.date, this.category, this.title, this.link);
}

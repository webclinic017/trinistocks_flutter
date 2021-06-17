import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trinistocks_flutter/apis/portfolio_api.dart';
import 'package:trinistocks_flutter/widgets/main_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:trinistocks_flutter/widgets/portfolio_book_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_gain_loss_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_market_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_sector_book_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_sector_gain_loss_value_horizontal_barchart.dart';
import 'package:trinistocks_flutter/widgets/portfolio_sector_market_value_horizontal_barchart.dart';

class PortfolioSummaryPage extends StatefulWidget {
  PortfolioSummaryPage({Key? key}) : super(key: key);

  @override
  _PortfolioSummaryPageState createState() => _PortfolioSummaryPageState();
}

class _PortfolioSummaryPageState extends State<PortfolioSummaryPage> {
  bool _loading = true;
  Widget marketValueBarchart = Text("");
  Widget sectorValueBarchart = Text("");
  Widget bookValueBarchart = Text("");
  Widget sectorBookValueBarchart = Text("");
  Widget gainLossBarchart = Text("");
  Widget sectorGainLossBarchart = Text("");

  @override
  void initState() {
    super.initState();
    PortfolioAPI.fetchPortfolioSummaryData().then((List portfolioData) {
      setState(() {
        //build the market value horizontal barchart
        marketValueBarchart =
            PortfolioMarketValueHorizontalBarChart(portfolioData);
        bookValueBarchart = PortfolioBookValueHorizontalBarChart(portfolioData);
        gainLossBarchart = PortfolioGainLossHorizontalBarChart(portfolioData);
        _loading = false;
      });
    });
    PortfolioAPI.fetchPortfolioSectorData().then((List sectorData) {
      setState(() {
        //build the market value horizontal barchart
        sectorValueBarchart =
            PortfolioSectorMarketValueHorizontalBarChart(sectorData);
        sectorBookValueBarchart =
            PortfolioSectorBookValueHorizontalBarChart(sectorData);
        sectorGainLossBarchart =
            PortfolioSectorGainLossHorizontalBarChart(sectorData);
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio Summary'),
        centerTitle: true,
      ),
      //add a drawer for navigation
      endDrawer: MainDrawer(),
      //setup futurebuilders to wait on the API data
      body: LoadingOverlay(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            marketValueBarchart,
            bookValueBarchart,
            gainLossBarchart,
            sectorValueBarchart,
            sectorBookValueBarchart,
            sectorGainLossBarchart,
          ],
        ),
        isLoading: _loading,
      ),
    );
  }
}

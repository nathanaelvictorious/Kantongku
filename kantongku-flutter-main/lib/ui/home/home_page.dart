import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/color.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/summary_monthly_model.dart';
import 'package:kantongku/repository/summary_repository.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userId = '';
  late int selectedChartPage;
  late final PageController chartListController;

  @override
  void initState() {
    getUserId();
    selectedChartPage = 0;
    chartListController = PageController(initialPage: selectedChartPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView(
          children: [
            summaryWidget(deviceWidth),
            chartListWidget(deviceWidth),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceWidth / 25),
              child: PageViewDotIndicator(
                size: Size(deviceWidth / 50, deviceWidth / 50),
                unselectedSize: Size(deviceWidth / 70, deviceWidth / 70),
                currentItem: selectedChartPage,
                count: 2,
                unselectedColor: Colors.black26,
                selectedColor: Theme.of(context).primaryColor,
                duration: const Duration(milliseconds: 200),
                boxShape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryWidget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: Column(
        children: [
          Text(
            'Ringkasan Keuangan',
            style: TextStyleComp.mediumBoldText(context),
          ),
          SizedBox(
            height: deviceWidth / 20,
          ),
          Container(
            padding: EdgeInsets.all(deviceWidth / 20),
            decoration: BoxDecoration(
                color: GlobalColors.lighterLightBlue,
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pendapatan',
                      style: TextStyleComp.mediumBoldText(context),
                    ),
                    FutureBuilder(
                        future: SummaryRepository.getData(userId, 'Pendapatan'),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'Rp ${NumberFormat('#,##0', 'ID').format(snapshot.data!.amount)}',
                              style: TextStyleComp.bigGreenText(context),
                            );
                          } else {
                            return SpinKitFadingCube(
                              color: Theme.of(context).primaryColor,
                              size: deviceWidth / 15,
                            );
                          }
                        })),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade600,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pengeluaran',
                      style: TextStyleComp.mediumBoldText(context),
                    ),
                    FutureBuilder(
                        future:
                            SummaryRepository.getData(userId, 'Pengeluaran'),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'Rp ${NumberFormat('#,##0', 'ID').format(snapshot.data!.amount)}',
                              style: TextStyleComp.bigRedText(context),
                            );
                          } else {
                            return SpinKitFadingCube(
                              color: Theme.of(context).primaryColor,
                              size: deviceWidth / 15,
                            );
                          }
                        }))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chartListWidget(deviceWidth) {
    return SizedBox(
      width: deviceWidth,
      height: deviceWidth / 1.19,
      child: PageView(
        allowImplicitScrolling: false,
        controller: chartListController,
        onPageChanged: (value) {
          setState(() {
            selectedChartPage = value;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth / 20),
            child: incomeChartWidget(deviceWidth),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth / 20),
            child: expenseChartWidget(deviceWidth),
          ),
        ],
      ),
    );
  }

  Widget incomeChartWidget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        deviceWidth / 20,
        0,
        deviceWidth / 20,
        deviceWidth / 20,
      ),
      child: Column(
        children: [
          Text(
            'Grafik Transaksi Pendapatan',
            style: TextStyleComp.mediumBoldText(context),
          ),
          FutureBuilder(
              future: SummaryRepository.getMonthlyData(userId, 'Pendapatan'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SummaryMonthly> sumMonthlyItems = snapshot.data!;
                  return SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      trackballBehavior: TrackballBehavior(
                          shouldAlwaysShow: true,
                          enable: true,
                          activationMode: ActivationMode.singleTap),
                      series: [
                        ColumnSeries<SummaryMonthly, dynamic>(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(deviceWidth / 70),
                              topRight: Radius.circular(deviceWidth / 70),
                            ),
                            dataSource: sumMonthlyItems,
                            xValueMapper: (SummaryMonthly sumMonth, _) =>
                                sumMonth.month,
                            yValueMapper: (SummaryMonthly sumMonth, _) =>
                                sumMonth.amount)
                      ]);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error!.toString());
                } else {
                  return SpinKitFadingCube(
                    color: Theme.of(context).primaryColor,
                    size: deviceWidth / 15,
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget expenseChartWidget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        deviceWidth / 20,
        0,
        deviceWidth / 20,
        deviceWidth / 20,
      ),
      child: Column(
        children: [
          Text(
            'Grafik Transaksi Pengeluaran',
            style: TextStyleComp.mediumBoldText(context),
          ),
          FutureBuilder(
              future: SummaryRepository.getMonthlyData(userId, 'Pengeluaran'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SummaryMonthly> sumMonthlyItems = snapshot.data!;
                  return SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      trackballBehavior: TrackballBehavior(
                          shouldAlwaysShow: true,
                          enable: true,
                          activationMode: ActivationMode.singleTap),
                      series: [
                        ColumnSeries<SummaryMonthly, dynamic>(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(deviceWidth / 70),
                              topRight: Radius.circular(deviceWidth / 70),
                            ),
                            dataSource: sumMonthlyItems,
                            xValueMapper: (SummaryMonthly sumMonth, _) =>
                                sumMonth.month,
                            yValueMapper: (SummaryMonthly sumMonth, _) =>
                                sumMonth.amount)
                      ]);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error!.toString());
                } else {
                  return SpinKitFadingCube(
                    color: Theme.of(context).primaryColor,
                    size: deviceWidth / 15,
                  );
                }
              }),
        ],
      ),
    );
  }

  Future refreshData() async {
    setState(() {});
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id')!;
    });
  }
}

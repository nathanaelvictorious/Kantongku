import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/color.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/transaction_each_category_model.dart';
import 'package:kantongku/repository/transaction_repository.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisPage extends StatefulWidget {
  final String userId;
  const AnalysisPage({required this.userId, super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String selectedDate = '', selectedDateTextBahasa = '';

  @override
  void initState() {
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    selectedDateTextBahasa =
        DateFormat('MMMM yyyy', 'ID').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Analisis Keuangan',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: analysisPageWidget(deviceWidth),
    );
  }

  Widget analysisPageWidget(deviceWidth) {
    return ListView(
      children: [
        monthPickerWidget(deviceWidth),
        pieChartWidget(deviceWidth),
        textDescriptionWidget(deviceWidth),
      ],
    );
  }

  Widget monthPickerWidget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: GestureDetector(
        onTap: () async {
          String? locale = 'id';
          final localeObj = Locale(locale);
          DateTime? selected = await showMonthYearPicker(
            context: context,
            initialDate: DateTime(DateTime.now().year, DateTime.now().month),
            firstDate: DateTime(2001),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month),
            locale: localeObj,
          );

          if (selected != null) {
            setState(() {
              selectedDate = DateFormat('yyyy-MM-dd').format(selected);
              selectedDateTextBahasa =
                  DateFormat('MMMM yyyy', 'id').format(selected);
            });
            setState(() {});
          }

          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.all(deviceWidth / 20),
          decoration: BoxDecoration(
              color: GlobalColors.lighterLightBlue,
              borderRadius:
                  BorderRadius.all(Radius.circular(deviceWidth / 50))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDateTextBahasa,
                style: TextStyleComp.mediumBoldText(context),
              ),
              Icon(
                FontAwesomeIcons.circleChevronDown,
                size: deviceWidth / 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pieChartWidget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(
        deviceWidth / 20,
      ),
      child: Column(
        children: [
          Text(
            'Transaksi Kamu Bulan $selectedDateTextBahasa',
            style: TextStyleComp.mediumBoldText(context),
          ),
          FutureBuilder(
              future: TransactionRepository.getPeriodicCategoryData(
                  widget.userId, selectedDate),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TransactionEachCategory> transactionEachCategoryItems =
                      snapshot.data!;
                  return SizedBox(
                    width: deviceWidth / 1.9,
                    child: SfCircularChart(
                      series: [
                        PieSeries<TransactionEachCategory, dynamic>(
                            dataLabelMapper: (TransactionEachCategory data, _) {
                              return data.text;
                            },
                            dataSource: transactionEachCategoryItems,
                            xValueMapper:
                                (TransactionEachCategory sumMonth, _) =>
                                    sumMonth.category,
                            yValueMapper:
                                (TransactionEachCategory sumMonth, _) =>
                                    sumMonth.amount,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelIntersectAction: LabelIntersectAction.none,
                                overflowMode: OverflowMode.shift,
                                showZeroValue: false,
                                labelPosition: ChartDataLabelPosition.outside,
                                connectorLineSettings: ConnectorLineSettings(
                                    type: ConnectorType.curve))),
                      ],
                    ),
                  );
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

  Widget textDescriptionWidget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth / 20),
      child: FutureBuilder(
          future: TransactionRepository.getPeriodicCategoryData(
              widget.userId, selectedDate),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              List<TransactionEachCategory> transItems = snapshot.data!;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: transItems.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transItems[index].category,
                          style: TextStyleComp.mediumBoldText(context),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,##0', 'ID').format(transItems[index].amount)}',
                          style: TextStyleComp.mediumText(context),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error!.toString());
            } else {
              return SpinKitFadingCube(
                color: Theme.of(context).primaryColor,
                size: deviceWidth / 15,
              ); // L
            }
          })),
    );
  }
}

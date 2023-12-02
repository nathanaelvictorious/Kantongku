import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/color.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/budget_model.dart';
import 'package:kantongku/repository/budget_repository.dart';
import 'package:kantongku/ui/budget/add_budget_page.dart';
import 'package:kantongku/ui/budget/detail_budget_page.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String userId = '', filterDateText = '', filterDateTextBahasa = '';

  @override
  void initState() {
    getUserId();
    filterDateText = DateFormat('yyyy-MM-dd').format(DateTime.now());
    filterDateTextBahasa = DateFormat('MMMM yyyy', 'ID').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddBudgetPage();
          })).then((value) {
            setState(() {});
          });
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView(
          children: [
            titlePage(deviceWidth),
            monthPickerWidget(deviceWidth),
            budgetPageWidgets(deviceWidth),
          ],
        ),
      ),
    );
  }

  Widget titlePage(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: Text(
        'Manajemen Anggaran',
        style: TextStyleComp.bigBoldPrimaryColorText(context),
      ),
    );
  }

  Widget monthPickerWidget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth / 20),
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
              filterDateText = DateFormat('yyyy-MM-dd').format(selected);
              filterDateTextBahasa =
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
                filterDateTextBahasa,
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

  Widget budgetPageWidgets(deviceWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceWidth / 20),
      child: FutureBuilder(
          future: BudgetRepository.getData(userId, filterDateText),
          builder: ((context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Budget> budgetItems = snapshot.data!;
              return Padding(
                padding: EdgeInsets.only(bottom: deviceWidth / 5),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: budgetItems.length,
                    itemBuilder: (context, index) {
                      return card(context, deviceWidth, index, budgetItems);
                    }),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCube(
                  color: Theme.of(context).primaryColor,
                  size: deviceWidth / 15,
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada anggaran',
                  style: TextStyleComp.smallBoldText(context),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyleComp.smallBoldText(context),
                ),
              );
            } else {
              return Center(
                child: SpinKitFadingCube(
                  color: Theme.of(context).primaryColor,
                  size: deviceWidth / 15,
                ),
              );
            }
          })),
    );
  }

  Widget card(context, deviceWidth, index, data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        deviceWidth / 20,
        0,
        deviceWidth / 20,
        deviceWidth / 20,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailBudgetPage(
              id: data[index].id,
              title: data[index].title,
              category: data[index].category,
              date: data[index].date,
              description: data[index].description,
              spendTotal: data[index].spendTotal,
              limit: data[index].limit,
            );
          })).then((value) {
            setState(() {});
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(deviceWidth / 40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(3, 5),
              ),
            ],
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(deviceWidth / 40),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth / 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy', 'ID').format(
                            DateFormat('yyyy-MM-dd').parse(data[index].date)),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleComp.smallBoldPrimaryColorText(context),
                      ),
                      SizedBox(
                        height: deviceWidth / 80,
                      ),
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: Text(
                          data[index].title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleComp.mediumBoldText(context),
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Row(
                              children: [
                                Text(
                                  'Rp ${NumberFormat('#,##0', 'ID').format(data[index].spendTotal)}/',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleComp.mediumBoldText(context),
                                ),
                                Text(
                                  'Rp ${NumberFormat('#,##0', 'ID').format(data[index].limit)}',
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyleComp.mediumBoldPrimaryColorText(
                                          context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/saving_model.dart';
import 'package:kantongku/repository/saving_repository.dart';
import 'package:kantongku/ui/saving/add_saving_page.dart';
import 'package:kantongku/ui/saving/detail_saving_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingPage extends StatefulWidget {
  const SavingPage({super.key});

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  String userId = '';

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddSavingPage();
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
            savingPageWidgets(deviceWidth),
          ],
        ),
      ),
    );
  }

  Widget titlePage(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: Text(
        'Penyimpanan Tabungan',
        style: TextStyleComp.bigBoldPrimaryColorText(context),
      ),
    );
  }

  Widget savingPageWidgets(deviceWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceWidth / 20),
      child: FutureBuilder(
          future: SavingRepository.getData(userId),
          builder: ((context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Saving> savingItems = snapshot.data!;
              return Padding(
                padding: EdgeInsets.only(bottom: deviceWidth / 5),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: savingItems.length,
                    itemBuilder: (context, index) {
                      return card(context, deviceWidth, index, savingItems);
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
                  'Belum ada tabungan',
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
                child: Text(
                  'Belum ada tabungan',
                  style: TextStyleComp.smallBoldText(context),
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
            return DetailSavingPage(
              id: data[index].id,
              title: data[index].title,
              description: data[index].description,
              currentBalance: data[index].currentBalance,
              goalAmount: data[index].goalAmount,
              isAchieved: data[index].isAchieved,
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
                                  'Rp ${NumberFormat('#,##0', 'ID').format(data[index].currentBalance)}/',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleComp.mediumBoldText(context),
                                ),
                                Text(
                                  'Rp ${NumberFormat('#,##0', 'ID').format(data[index].goalAmount)}',
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
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Text(
                              data[index].isAchieved
                                  ? 'Sudah tercapai'
                                  : 'Belum tercapai',
                              overflow: TextOverflow.ellipsis,
                              style: data[index].isAchieved
                                  ? TextStyleComp.smallBoldPrimaryColorText(
                                      context)
                                  : TextStyleComp.smallBoldRedText(context),
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

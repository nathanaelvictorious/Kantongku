import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/bill_model.dart';
import 'package:kantongku/repository/bill_repository.dart';
import 'package:kantongku/ui/bill/add_bill_page.dart';
import 'package:kantongku/ui/bill/detail_bill_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Tagihan',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddBillPage();
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceWidth / 20),
              child: billPageWidgets(deviceWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget billPageWidgets(deviceWidth) {
    return FutureBuilder(
        future: BillRepository.getData(userId),
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Bill> billItems = snapshot.data!;
            return Padding(
              padding: EdgeInsets.only(bottom: deviceWidth / 5),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: billItems.length,
                  itemBuilder: (context, index) {
                    return card(context, deviceWidth, index, billItems);
                  }),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data',
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
                'Tidak ada data',
                style: TextStyleComp.smallBoldText(context),
              ),
            );
          }
        }));
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
            return DetailBillPage();
          }));
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
                        'Jatuh Tempo: ${DateFormat('EEEE, dd MMMM yyyy', 'ID').format(DateFormat('yyyy-MM-dd').parse(data[index].dueDate))}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleComp.smallBoldRedText(context),
                      ),
                      SizedBox(
                        height: deviceWidth / 80,
                      ),
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: Text(
                          data[index].name,
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
                            Text(
                              'Rp ${NumberFormat('#,##0', 'ID').format(data[index].amount)}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
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

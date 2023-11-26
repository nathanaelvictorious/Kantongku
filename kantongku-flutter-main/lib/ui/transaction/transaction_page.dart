import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kantongku/component/color.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/ui/bill/bill_page.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: transactWidgets(deviceWidth),
    );
  }

  Widget transactWidgets(deviceWidth) {
    return ListView(
      children: [
        toBillPageButton(deviceWidth),
        titlePage(deviceWidth),
      ],
    );
  }

  Widget toBillPageButton(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const BillPage();
          }));
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
                'Daftar Tagihan',
                style: TextStyleComp.mediumBoldText(context),
              ),
              Icon(
                FontAwesomeIcons.circleArrowRight,
                size: deviceWidth / 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titlePage(deviceWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth / 20),
      child: Text(
        'Transaksi',
        style: TextStyleComp.bigBoldPrimaryColorText(context),
      ),
    );
  }
}

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/ui/budget/budget_page.dart';
import 'package:kantongku/ui/login/login_page.dart';
import 'package:kantongku/ui/transaction/transaction_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int? selectedPage;
  List<Widget> pageList = [
    const SizedBox(),
    const TransactionPage(),
    const BudgetPage(),
    const SizedBox(),
  ];

  void onNavbarTapped(int index) {
    setState(() {
      selectedPage = index;
      super.setState(() {});
    });
  }

  @override
  void initState() {
    selectedPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'KantongKu',
          style: TextStyleComp.bigBoldPrimaryColorText(context),
        ),
        actions: [
          // FutureBuilder(
          //     future: UserRepository.getUser(),
          //     builder: (context, snapshot) {
          //       List<User> userItems = snapshot.data!;

          //       return Text(userItems[0].name);
          //     })
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false);
              },
              icon: Icon(
                FontAwesomeIcons.solidCircleUser,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
      bottomNavigationBar: bottomBar(deviceWidth),
      body: pageList.elementAt(selectedPage!),
    );
  }

  Widget bottomBar(deviceWidth) {
    return CustomNavigationBar(
      strokeColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 0,
      bubbleCurve: Curves.ease,
      iconSize: deviceWidth / 20,
      selectedColor: Theme.of(context).primaryColor,
      unSelectedColor: Colors.grey[500],
      items: [
        CustomNavigationBarItem(
          selectedTitle: Text(
            "Beranda",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: deviceWidth / 30,
                color: Theme.of(context).primaryColor),
          ),
          title: Text(
            "Beranda",
            style: TextStyle(
              fontSize: deviceWidth / 30,
            ),
          ),
          icon: const Icon(FontAwesomeIcons.house),
        ),
        CustomNavigationBarItem(
          selectedTitle: Text(
            "Transaksi",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: deviceWidth / 30,
                color: Theme.of(context).primaryColor),
          ),
          title: Text(
            "Transaksi",
            style: TextStyle(
              fontSize: deviceWidth / 30,
            ),
          ),
          icon: const Icon(FontAwesomeIcons.dollarSign),
        ),
        CustomNavigationBarItem(
          selectedTitle: Text(
            "Anggaran",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: deviceWidth / 30,
                color: Theme.of(context).primaryColor),
          ),
          title: Text(
            "Anggaran",
            style: TextStyle(
              fontSize: deviceWidth / 30,
            ),
          ),
          icon: const Icon(FontAwesomeIcons.suitcase),
        ),
        CustomNavigationBarItem(
          selectedTitle: Text(
            "Analisis",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: deviceWidth / 30,
                color: Theme.of(context).primaryColor),
          ),
          title: Text(
            "Analisis",
            style: TextStyle(
              fontSize: deviceWidth / 30,
            ),
          ),
          icon: const Icon(FontAwesomeIcons.chartColumn),
        ),
      ],
      currentIndex: selectedPage!,
      onTap: (index) {
        setState(() {
          selectedPage = index;
        });
      },
    );
  }
}

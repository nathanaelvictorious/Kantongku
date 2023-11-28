import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/repository/user_repository.dart';
import 'package:kantongku/ui/budget/budget_page.dart';
import 'package:kantongku/ui/saving/saving_page.dart';
import 'package:kantongku/ui/transaction/transaction_page.dart';

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
    const SavingPage(),
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
                modalLogout(deviceWidth);
              },
              icon: Icon(
                FontAwesomeIcons.arrowRightFromBracket,
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
            "Tabungan",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: deviceWidth / 30,
                color: Theme.of(context).primaryColor),
          ),
          title: Text(
            "Tabungan",
            style: TextStyle(
              fontSize: deviceWidth / 30,
            ),
          ),
          icon: const Icon(FontAwesomeIcons.piggyBank),
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

  void modalLogout(deviceWidth) {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(deviceWidth / 20),
              topRight: Radius.circular(deviceWidth / 20)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(deviceWidth / 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Apakah anda yakin ingin logout?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: deviceWidth / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: deviceWidth / 3,
                          padding: EdgeInsets.only(
                              top: deviceWidth / 20, bottom: deviceWidth / 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth / 40),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceWidth / 30),
                              child: Text(
                                "BATAL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceWidth / 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: deviceWidth / 3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.circular(deviceWidth / 40),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              UserRepository.logOut(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceWidth / 30),
                              child: Text(
                                "LOGOUT",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceWidth / 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}

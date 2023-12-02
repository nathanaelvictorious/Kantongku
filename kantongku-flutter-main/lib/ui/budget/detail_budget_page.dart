import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/transaction_model.dart';
import 'package:kantongku/repository/budget_repository.dart';
import 'package:kantongku/ui/budget/update_budget_page.dart';
import 'package:kantongku/ui/transaction/detail_transaction_page.dart';

class DetailBudgetPage extends StatefulWidget {
  final String id;
  final String category;
  final String title;
  final int spendTotal;
  final int limit;
  final String date;
  final String description;

  const DetailBudgetPage({
    required this.id,
    required this.category,
    required this.title,
    required this.spendTotal,
    required this.limit,
    required this.date,
    required this.description,
    super.key,
  });

  @override
  State<DetailBudgetPage> createState() => _DetailBudgetPageState();
}

class _DetailBudgetPageState extends State<DetailBudgetPage> {
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
          'Detail Anggaran',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: ListView(
        children: [
          detailBudgetWidgets(deviceWidth),
          buttonWidgets(deviceWidth),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth / 20),
            child: Divider(
              color: Colors.grey.shade700,
            ),
          ),
          transactionPageWidgets(deviceWidth),
        ],
      ),
    );
  }

  Widget detailBudgetWidgets(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: IntrinsicHeight(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Anggaran:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                            Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumText(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth / 80,
                      ),
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tanggal:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy', 'ID').format(
                                  DateFormat('yyyy-MM-dd').parse(widget.date)),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumText(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth / 80,
                      ),
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Anggaran Terpakai:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                Row(
                                  children: [
                                    Text(
                                      'Rp ${NumberFormat('#,##0', 'ID').format(widget.spendTotal)}/',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyleComp.mediumText(context),
                                    ),
                                    Text(
                                      'Rp ${NumberFormat('#,##0', 'ID').format(widget.limit)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyleComp
                                          .mediumBoldPrimaryColorText(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth / 80,
                      ),
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                            Text(
                              widget.description,
                              style: TextStyleComp.mediumText(context),
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

  Widget buttonWidgets(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: IntrinsicHeight(
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return UpdateBudgetPage(
                                id: widget.id,
                                title: widget.title,
                                limit: widget.limit.toString(),
                                description: widget.description,
                              );
                            })).then((value) {
                              setState(() {});
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceWidth / 80),
                            child: Text(
                              'Ubah Data',
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth / 20,
                      ),
                      SizedBox(
                        width: deviceWidth / 1.3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            modalDelete(deviceWidth);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceWidth / 80),
                            child: Text(
                              'Hapus Data',
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                          ),
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

  Widget transactionPageWidgets(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                deviceWidth / 20, deviceWidth / 50, deviceWidth / 20, 0),
            child: Text(
              'Riwayat transaksi',
              style: TextStyleComp.mediumBoldPrimaryColorText(context),
            ),
          ),
          SizedBox(
            height: deviceWidth / 20,
          ),
          FutureBuilder(
              future: BudgetRepository.getTransaction(widget.id),
              builder: ((context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Transaction> transBudgetItems = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth / 5),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: transBudgetItems.length,
                        itemBuilder: (context, index) {
                          return card(
                              context, deviceWidth, index, transBudgetItems);
                        }),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCube(
                      color: Theme.of(context).primaryColor,
                      size: deviceWidth / 15,
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada transaksi anggaran',
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
        ],
      ),
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
            return DetailTransactionPage(
                id: data[index].id,
                savingId: data[index].savingId,
                budgetId: data[index].budgetId,
                category: data[index].category,
                amount: data[index].amount,
                dateTime: data[index].dateTime,
                description: data[index].description);
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data[index].dateTime,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.smallItalicText(context),
                            ),
                            Text(
                                'Rp ${NumberFormat('#,##0', 'ID').format(data[index].amount)}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleComp.mediumPrimaryColorText(
                                    context)),
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

  void modalDelete(deviceWidth) {
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
                      "Apakah anda yakin ingin hapus data ini?",
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
                              GlobalModal.loadingModal(deviceWidth, context);
                              BudgetRepository.deleteData(context, widget.id);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceWidth / 30),
                              child: Text(
                                "HAPUS",
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/repository/bill_repository.dart';
import 'package:kantongku/ui/bill/update_bill_page.dart';

class DetailBillPage extends StatefulWidget {
  final String id;
  final String name;
  final int amount;
  final String dueDate;
  final String description;
  final bool isPaid;

  const DetailBillPage({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.description,
    required this.isPaid,
    super.key,
  });

  @override
  State<DetailBillPage> createState() => _DetailBillPageState();
}

class _DetailBillPageState extends State<DetailBillPage> {
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
          'Detail Tagihan',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: ListView(
        children: [
          detailBillWidgets(deviceWidth),
          buttonWidgets(deviceWidth),
        ],
      ),
    );
  }

  Widget detailBillWidgets(deviceWidth) {
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
                              'Jatuh Tempo:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldRedText(context),
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy', 'ID').format(
                                  DateFormat('yyyy-MM-dd')
                                      .parse(widget.dueDate)),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumRedText(context),
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
                              'Tagihan:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                            Text(
                              widget.name,
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
                              'Nominal:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                            Text(
                              'Rp ${NumberFormat('#,##0', 'ID').format(widget.amount)}',
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
                              'Status:',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleComp.mediumBoldText(context),
                            ),
                            Text(
                              widget.isPaid ? 'Sudah dibayar' : 'Belum dibayar',
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
                              return UpdateBillPage(
                                  id: widget.id,
                                  name: widget.name,
                                  amount: widget.amount,
                                  dueDate: widget.dueDate,
                                  description: widget.description,
                                  isPaid: widget.isPaid);
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
                              BillRepository.deleteData(context, widget.id);
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

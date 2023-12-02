import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/bill_model.dart';
import 'package:kantongku/model/budget_model.dart';
import 'package:kantongku/model/saving_model.dart';
import 'package:kantongku/repository/bill_repository.dart';
import 'package:kantongku/repository/budget_repository.dart';
import 'package:kantongku/repository/saving_repository.dart';
import 'package:kantongku/repository/transaction_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  bool isBudget = false, isBill = false;
  String userId = '',
      getDateNow = '',
      selectedDate = '',
      selectedCategory = '',
      selectedBudget = '',
      selectedBill = '',
      selectedSaving = '';
  List<Budget> budgetItems = [];
  List<Saving> savingItems = [];
  List<Bill> billItems = [];
  TextEditingController amountCtl = TextEditingController();
  TextEditingController descCtl = TextEditingController();
  final CurrencyTextInputFormatter amountFormatter = CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
  );
  final addTransactFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    getDateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    selectedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

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
          'Tambah Transaksi',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(deviceWidth / 20),
        child: addTransactionForm(deviceWidth),
      ),
    );
  }

  Widget addTransactionForm(deviceWidth) {
    return Form(
      key: addTransactFormKey,
      child: ListView(
        children: [
          categoryDropDown(deviceWidth),
          selectedCategory == 'Pengeluaran'
              ? Column(
                  children: [
                    checklistIsBill(deviceWidth),
                    checklistToBudget(deviceWidth),
                  ],
                )
              : const SizedBox(),
          isBill ? billDropDown(deviceWidth) : const SizedBox(),
          isBudget ? budgetDropDown(deviceWidth) : const SizedBox(),
          selectedCategory == 'Tabungan'
              ? savingDropDown(deviceWidth)
              : const SizedBox(),
          amountTransTextFormField(deviceWidth),
          descTransTextFormField(deviceWidth),
          sendButton(deviceWidth),
        ],
      ),
    );
  }

  Widget categoryDropDown(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori Transaksi',
            style: TextStyleComp.mediumText(context),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              isExpanded: false,
              items: [
                'Pendapatan',
                'Pengeluaran',
                'Tabungan',
              ]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(238, 238, 238, 1),
                hintText: 'Pilih kategori transaksi',
                hintStyle: TextStyleComp.mediumText(context),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(deviceWidth / 50)),
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(deviceWidth / 50)),
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value.toString();
                  isBudget = false;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Harus dipilih';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget budgetDropDown(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anggaran',
            style: TextStyleComp.mediumText(context),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: FutureBuilder(
                future: BudgetRepository.getData(userId, getDateNow),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    budgetItems.clear();
                    budgetItems.addAll(snapshot.data!);
                    return DropdownButtonFormField(
                      isExpanded: false,
                      items: budgetItems
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.title),
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(238, 238, 238, 1),
                        hintText: 'Pilih anggaran',
                        hintStyle: TextStyleComp.mediumText(context),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(deviceWidth / 50)),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(deviceWidth / 50)),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedBudget = value.toString();
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Harus dipillih';
                        }
                        return null;
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SpinKitFadingCube(
                        color: Theme.of(context).primaryColor,
                        size: deviceWidth / 15,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget checklistIsBill(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Apakah transaksi tagihan?',
          style: TextStyleComp.mediumBoldText(context),
        ),
        checkColor: Colors.black,
        dense: true,
        visualDensity: VisualDensity.compact,
        value: isBill,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          setState(() => isBill = value!);
        },
      ),
    );
  }

  Widget checklistToBudget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Masuk ke anggaran?',
          style: TextStyleComp.mediumBoldText(context),
        ),
        checkColor: Colors.black,
        dense: true,
        visualDensity: VisualDensity.compact,
        value: isBudget,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          setState(() => isBudget = value!);
        },
      ),
    );
  }

  Widget billDropDown(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tagihan',
            style: TextStyleComp.mediumText(context),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: FutureBuilder(
                future: BillRepository.getData(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    billItems.clear();
                    billItems.addAll(snapshot.data!);
                    return DropdownButtonFormField(
                      isExpanded: false,
                      items: billItems
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(238, 238, 238, 1),
                        hintText: 'Pilih tagihan',
                        hintStyle: TextStyleComp.mediumText(context),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(deviceWidth / 50)),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(deviceWidth / 50)),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedBill = value.toString();
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Harus dipilih';
                        }
                        return null;
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SpinKitFadingCube(
                        color: Theme.of(context).primaryColor,
                        size: deviceWidth / 15,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget savingDropDown(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tabungan',
            style: TextStyleComp.mediumText(context),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: FutureBuilder(
                future: SavingRepository.getData(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    savingItems.clear();
                    savingItems.addAll(snapshot.data!);
                    return DropdownButtonFormField(
                      isExpanded: false,
                      items: savingItems
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.title),
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(238, 238, 238, 1),
                        hintText: 'Pilih tabungan',
                        hintStyle: TextStyleComp.mediumText(context),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(deviceWidth / 50)),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(deviceWidth / 50)),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedSaving = value.toString();
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Harus dipilih';
                        }
                        return null;
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SpinKitFadingCube(
                        color: Theme.of(context).primaryColor,
                        size: deviceWidth / 15,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget amountTransTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nominal Transaksi',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: amountCtl,
            autofocus: false,
            keyboardType: TextInputType.number,
            inputFormatters: [amountFormatter],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan nominal transaksi',
              hintStyle: TextStyleComp.mediumText(context),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget descTransTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: descCtl,
            maxLines: 3,
            autofocus: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan deskripsi',
              hintStyle: TextStyleComp.mediumText(context),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceWidth / 50)),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget sendButton(deviceWidth) {
    return ElevatedButton(
        onPressed: () async {
          if (addTransactFormKey.currentState!.validate()) {
            GlobalModal.loadingModal(deviceWidth, context);
            if (selectedCategory == 'Tabungan') {
              TransactionRepository.addDataTransSaving(
                context,
                userId,
                selectedSaving,
                selectedCategory,
                amountFormatter.getUnformattedValue().toString(),
                selectedDate,
                descCtl.text,
              );
            } else if ((selectedCategory == 'Pendapatan' ||
                    selectedCategory == 'Pengeluaran') &&
                !isBudget &&
                !isBill) {
              TransactionRepository.addDataWithoutBudgetSaving(
                context,
                userId,
                selectedCategory,
                amountFormatter.getUnformattedValue().toString(),
                selectedDate,
                descCtl.text,
              );
            } else if (selectedCategory == 'Pengeluaran' &&
                isBudget &&
                !isBill) {
              TransactionRepository.addDataTransBudget(
                  context,
                  userId,
                  selectedBudget,
                  selectedCategory,
                  amountFormatter.getUnformattedValue().toString(),
                  selectedDate,
                  descCtl.text);
            } else if (selectedCategory == 'Pengeluaran' &&
                isBill &&
                !isBudget) {
              TransactionRepository.addDataTransBillWithoutBudget(
                  context,
                  userId,
                  selectedBill,
                  selectedCategory,
                  amountFormatter.getUnformattedValue().toString(),
                  selectedDate,
                  descCtl.text);
            } else if (selectedCategory == 'Pengeluaran' &&
                isBill &&
                isBudget) {
              TransactionRepository.addDataTransBillWithBudget(
                  context,
                  userId,
                  selectedBudget,
                  selectedBill,
                  selectedCategory,
                  amountFormatter.getUnformattedValue().toString(),
                  selectedDate,
                  descCtl.text);
            } else {}
          } else {
            GlobalSnackBar.show(context, 'Ada form yang belum diisi!');
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: deviceWidth / 50),
          child: Text(
            'Simpan',
            style: TextStyleComp.mediumBoldText(context),
          ),
        ));
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('id')!;
    });
  }
}

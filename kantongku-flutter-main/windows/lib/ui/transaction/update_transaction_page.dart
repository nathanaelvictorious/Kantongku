import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/model/budget_model.dart';
import 'package:kantongku/model/saving_model.dart';
import 'package:kantongku/repository/budget_repository.dart';
import 'package:kantongku/repository/saving_repository.dart';
import 'package:kantongku/repository/transaction_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTransactionPage extends StatefulWidget {
  final String id;
  final String? savingId;
  final String? budgetId;
  final String category;
  final int amount;
  final String description;
  const UpdateTransactionPage({
    required this.id,
    required this.savingId,
    required this.budgetId,
    required this.category,
    required this.amount,
    required this.description,
    super.key,
  });

  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  bool isChangeSaving = false, isChangeBudget = false;
  String userId = '',
      getDateNow = '',
      selectedCategory = '',
      selectedBudget = '',
      selectedSaving = '';
  List<Budget> budgetItems = [];
  List<Saving> savingItems = [];
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
    getUserId();
    getDateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    amountCtl = TextEditingController(text: widget.amount.toString());
    descCtl = TextEditingController(text: widget.description);
    selectedCategory = widget.category;
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
          'Update Transaksi',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(deviceWidth / 20),
        child: updateTransactionForm(deviceWidth),
      ),
    );
  }

  Widget updateTransactionForm(deviceWidth) {
    return Form(
      key: addTransactFormKey,
      child: ListView(
        children: [
          selectedCategory == 'Tabungan'
              ? checklistChangeSaving(deviceWidth)
              : const SizedBox(),
          selectedCategory == 'Pengeluaran' && widget.budgetId != null
              ? checklistChangeBudget(deviceWidth)
              : const SizedBox(),
          selectedCategory == 'Tabungan' && isChangeSaving
              ? savingDropDown(deviceWidth)
              : const SizedBox(),
          selectedCategory == 'Pengeluaran' &&
                  widget.budgetId != null &&
                  isChangeBudget
              ? budgetDropDown(deviceWidth)
              : const SizedBox(),
          amountTransTextFormField(deviceWidth),
          descTransTextFormField(deviceWidth),
          sendButton(deviceWidth),
        ],
      ),
    );
  }

  Widget checklistChangeBudget(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Ingin ganti anggaran',
          style: TextStyleComp.mediumBoldText(context),
        ),
        dense: true,
        checkColor: Colors.black,
        visualDensity: VisualDensity.compact,
        value: isChangeBudget,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          setState(() => isChangeBudget = value!);
        },
      ),
    );
  }

  Widget checklistChangeSaving(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Ingin ganti tabungan',
          style: TextStyleComp.mediumBoldText(context),
        ),
        dense: true,
        checkColor: Colors.black,
        visualDensity: VisualDensity.compact,
        value: isChangeSaving,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          setState(() => isChangeSaving = value!);
        },
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
                        selectedBudget = value.toString();
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
                        selectedSaving = value.toString();
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
              TransactionRepository.updateDataTransSaving(
                  context,
                  widget.id,
                  selectedSaving == '' ? widget.savingId : selectedSaving,
                  amountFormatter.getUnformattedValue() == 0
                      ? widget.amount.toString()
                      : amountFormatter.getUnformattedValue().toString(),
                  descCtl.text);
            } else if (selectedCategory == 'Pendapatan') {
              TransactionRepository.updateDataWithoutBudgetSaving(
                  context,
                  widget.id,
                  amountFormatter.getUnformattedValue() == 0
                      ? widget.amount.toString()
                      : amountFormatter.getUnformattedValue().toString(),
                  descCtl.text);
            } else if (selectedCategory == 'Pengeluaran' &&
                widget.budgetId == null) {
              TransactionRepository.updateDataWithoutBudgetSaving(
                  context,
                  widget.id,
                  amountFormatter.getUnformattedValue() == 0
                      ? widget.amount.toString()
                      : amountFormatter.getUnformattedValue().toString(),
                  descCtl.text);
            } else if (selectedCategory == 'Pengeluaran' &&
                widget.budgetId != null) {
              TransactionRepository.updateDataTransBudget(
                  context,
                  widget.id,
                  selectedBudget == '' ? widget.budgetId : selectedBudget,
                  amountFormatter.getUnformattedValue() == 0
                      ? widget.amount.toString()
                      : amountFormatter.getUnformattedValue().toString(),
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

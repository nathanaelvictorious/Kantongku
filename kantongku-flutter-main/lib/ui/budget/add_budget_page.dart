import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/component/snackbar.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/repository/budget_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  String selectedDate = '';
  String selectedCategory = '';
  String userId = '';
  TextEditingController dateCtl = TextEditingController();
  TextEditingController titleCtl = TextEditingController();
  TextEditingController limitCtl = TextEditingController();
  TextEditingController descCtl = TextEditingController();
  final CurrencyTextInputFormatter limitFormatter = CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
  );

  final addBudgetFormKey = GlobalKey<FormState>();

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
          'Tambah Anggaran',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(deviceWidth / 20),
        child: addBugdetForm(deviceWidth),
      ),
    );
  }

  Widget addBugdetForm(deviceWidth) {
    return Form(
      key: addBudgetFormKey,
      child: ListView(
        children: [
          categoryDropdown(deviceWidth),
          dateBudgetTextFormField(deviceWidth),
          nameBudgetTextFormField(deviceWidth),
          limitBudgetTextFormField(deviceWidth),
          descBudgetTextFormField(deviceWidth),
          sendButton(deviceWidth),
        ],
      ),
    );
  }

  Widget categoryDropdown(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori Anggaran',
            style: TextStyleComp.mediumText(context),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
                isExpanded: true,
                items: [
                  'Belanja',
                  'Cicilan',
                  'Hiburan',
                  'Kesehatan',
                  'Konsumsi',
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
                  fillColor: Colors.grey.shade200,
                  hintText: 'Pilih kategori anggaran',
                  hintStyle: TextStyleComp.mediumText(context),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(deviceWidth / 50)),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(deviceWidth / 50)),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Harus dipilih';
                  }
                  return null;
                },
                onChanged: (value) {
                  selectedCategory = value.toString();
                }),
          ),
        ],
      ),
    );
  }

  Widget dateBudgetTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanggal',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: dateCtl,
            autofocus: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            enabled: true,
            readOnly: true,
            onTap: () async {
              DateTime? date = DateTime(1900);
              FocusScope.of(context).requestFocus(FocusNode());

              date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2200),
              );

              selectedDate = DateFormat('yyyy-MM-dd').format(date!);
              dateCtl.text =
                  DateFormat('EEEE, dd MMMM yyyy', 'ID').format(date);
            },
            decoration: InputDecoration(
              suffixIcon: Icon(
                FontAwesomeIcons.calendarDay,
                size: deviceWidth / 20,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Pilih tanggal anggaran',
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
                return 'Harus dipilih';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget nameBudgetTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Anggaran',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: titleCtl,
            autofocus: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan nama anggaran',
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

  Widget limitBudgetTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batas Anggaran',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: limitCtl,
            autofocus: false,
            keyboardType: TextInputType.number,
            inputFormatters: [limitFormatter],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan nominal batas anggaran',
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

  Widget descBudgetTextFormField(deviceWidth) {
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
          if (addBudgetFormKey.currentState!.validate()) {
            GlobalModal.loadingModal(deviceWidth, context);
            BudgetRepository.addData(
              context,
              userId,
              titleCtl.text,
              selectedCategory,
              limitFormatter.getUnformattedValue().toString(),
              descCtl.text,
              selectedDate,
            );
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

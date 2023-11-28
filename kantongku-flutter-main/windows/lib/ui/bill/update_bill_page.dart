import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kantongku/component/modal.dart';
import 'package:kantongku/component/text_style.dart';
import 'package:kantongku/repository/bill_repository.dart';

class UpdateBillPage extends StatefulWidget {
  final String id;
  final String name;
  final int amount;
  final String dueDate;
  final String description;
  final bool isPaid;

  const UpdateBillPage(
      {required this.id,
      required this.name,
      required this.amount,
      required this.dueDate,
      required this.description,
      required this.isPaid,
      super.key});

  @override
  State<UpdateBillPage> createState() => _UpdateBillPageState();
}

class _UpdateBillPageState extends State<UpdateBillPage> {
  String selectedDate = '', selectedIsPaid = '';
  TextEditingController dateCtl = TextEditingController();
  TextEditingController nameCtl = TextEditingController();
  TextEditingController amountCtl = TextEditingController();
  TextEditingController descCtl = TextEditingController();
  final CurrencyTextInputFormatter amountFormatter = CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
  );

  @override
  void initState() {
    selectedDate = widget.dueDate;
    selectedIsPaid = widget.isPaid ? 'Sudah dibayar' : 'Belum dibayar';
    dateCtl = TextEditingController(
        text: DateFormat('EEEE, dd MMMM yyyy', 'ID')
            .format(DateTime.parse(widget.dueDate)));
    nameCtl = TextEditingController(text: widget.name);
    amountCtl = TextEditingController(text: widget.amount.toString());
    descCtl = TextEditingController(text: widget.description);
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
          'Update Data Tagihan',
          style: TextStyleComp.mediumBoldPrimaryColorText(context),
        ),
      ),
      body: updateBillForm(deviceWidth),
    );
  }

  Widget updateBillForm(deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth / 20),
      child: ListView(
        children: [
          isPaidDropDown(deviceWidth),
          dateBilllTextFormField(deviceWidth),
          nameBillTextFormField(deviceWidth),
          amountBillTextFormField(deviceWidth),
          descBillTextFormField(deviceWidth),
          sendButton(deviceWidth),
        ],
      ),
    );
  }

  Widget isPaidDropDown(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Tagihan',
            style: TextStyleComp.mediumText(context),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
                value: selectedIsPaid,
                isExpanded: false,
                items: ['Sudah dibayar', 'Belum dibayar']
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
                  hintText: 'Pilih status bayar',
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
                onChanged: (value) {
                  selectedIsPaid = value.toString();
                }),
          ),
        ],
      ),
    );
  }

  Widget dateBilllTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanggal Tagihan',
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
                lastDate: DateTime.now(),
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
              hintText: 'Pilih tanggal tagihan',
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

  Widget nameBillTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Tagihan',
            style: TextStyleComp.mediumText(context),
          ),
          TextFormField(
            controller: nameCtl,
            autofocus: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: 'Masukkan nama tagihan',
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

  Widget amountBillTextFormField(deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: deviceWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nominal',
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
              hintText: 'Masukkan nominal tagihan',
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

  Widget descBillTextFormField(deviceWidth) {
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
          GlobalModal.loadingModal(deviceWidth, context);
          BillRepository.updateData(
            context,
            widget.id,
            selectedDate,
            nameCtl.text,
            amountFormatter.getUnformattedValue() == 0
                ? widget.amount.toString()
                : amountFormatter.getUnformattedValue().toString(),
            descCtl.text,
            selectedIsPaid == 'Belum dibayar' ? '0' : '1',
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: deviceWidth / 50),
          child: Text(
            'Simpan',
            style: TextStyleComp.mediumBoldText(context),
          ),
        ));
  }
}

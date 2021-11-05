import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor_app/services/firebase_services.dart';
import 'package:intl/intl.dart';

class AddEditCoupon extends StatefulWidget {
  static const String id = 'update-coupon';
  final DocumentSnapshot document;

  AddEditCoupon({this.document});

  @override
  _AddEditCouponState createState() => _AddEditCouponState();
}

class _AddEditCouponState extends State<AddEditCoupon> {
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  DateTime _selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var titleText = TextEditingController();
  var detailsText = TextEditingController();
  var discountRate = TextEditingController();
  bool _active = false;

  _selectDate(context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        String formattedText = DateFormat('yyyy-MM-dd').format(_selectedDate);
        dateText.text = formattedText;
      });
  }

  @override
  void initState() {
    if (widget.document != null)
      setState(() {
        titleText.text = widget.document.data()['title'];
        discountRate.text = widget.document.data()['discountRate'].toString();
        detailsText.text = widget.document.data()['details'].toString();
        dateText.text = widget.document.data()['Expiry'].toDate().toString();
        _active = widget.document.data()['active'];
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Add / Edit Coupon',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleText,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter coupon title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Coupn title',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              TextFormField(
                controller: discountRate,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Discount %';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Discount %',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: dateText,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Apply Expiry Date';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Expiry Date',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Icon(Icons.date_range_outlined),
                  ),
                ),
              ),
              TextFormField(
                controller: detailsText,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Coupon details';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Coupon Details',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                title: Text('Activate Coupon'),
                value: _active,
                onChanged: (bool newValue) {
                  setState(() {
                    _active = !_active;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          EasyLoading.show(status: 'Please wait..');
                          _services
                              .saveCoupon(
                            document: widget.document,
                            title: titleText.text.toUpperCase(),
                            details: detailsText.text,
                            discountRate: int.parse(discountRate.text),
                            expiry: _selectedDate,
                            active: _active,
                          )
                              .then((value) {
                            setState(() {
                              titleText.clear();
                              discountRate.clear();
                              detailsText.clear();
                              _active = false;
                            });
                            EasyLoading.showSuccess(
                                'Saved coupon successfully');
                          });
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

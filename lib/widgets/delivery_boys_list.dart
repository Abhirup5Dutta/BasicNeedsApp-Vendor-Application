import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_vendor_app/services/firebase_services.dart';
import 'package:grocery_vendor_app/services/order_services.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryBoysList extends StatefulWidget {
  final DocumentSnapshot document;

  DeliveryBoysList(this.document);
  @override
  _DeliveryBoysListState createState() => _DeliveryBoysListState();
}

class _DeliveryBoysListState extends State<DeliveryBoysList> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();

  GeoPoint _shopLocation;

  @override
  void initState() {
    _services.getShopDetails().then((value) {
      if (mounted) {
        if (value != null) {
          setState(() {
            _shopLocation = value.data()['location'];
          });
        }
      } else {
        print('No data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(
                'Select Delivery Boy',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _services.boys
                    .where('accVerified', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      GeoPoint location = document.data()['location'];
                      double distanceInMeters = _shopLocation == null
                          ? 0.0
                          : Geolocator.distanceBetween(
                                  _shopLocation.latitude,
                                  _shopLocation.longitude,
                                  location.latitude,
                                  location.longitude) /
                              1000;
                      if (distanceInMeters > 10) {
                        return Container();
                      }
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              EasyLoading.show(status: 'Assigning Boys');
                              _services
                                  .selectBoys(
                                orderId: widget.document.id,
                                email: document.data()['email'],
                                phone: document.data()['mobile'],
                                name: document.data()['name'],
                                location: document.data()['location'],
                                image: document.data()['imageUrl'],
                              )
                                  .then((value) {
                                EasyLoading.showSuccess(
                                    'Assigned Delivery Boy');
                                Navigator.pop(context);
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(document.data()['imageUrl']),
                            ),
                            title: Text(document.data()['name']),
                            subtitle: Text(
                                '${distanceInMeters.toStringAsFixed(0)} Km'), // need to find distance
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.map,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    GeoPoint location =
                                        document.data()['location'];
                                    _orderServices.launcchMap(
                                        location, document.data()['name']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.phone,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    _orderServices.launchCall(
                                        'tel:${document.data()['mobile']}');
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

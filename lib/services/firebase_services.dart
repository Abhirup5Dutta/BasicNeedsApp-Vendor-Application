import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference vendorbanner =
      FirebaseFirestore.instance.collection('vendorbanner');
  CollectionReference coupons =
      FirebaseFirestore.instance.collection('coupons');
  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> publishProduct({id}) {
    return products.doc(id).update({
      'published': true,
    });
  }

  Future<void> unPublishProduct({id}) {
    return products.doc(id).update({
      'published': false,
    });
  }

  Future<void> deleteProduct({id}) {
    return products.doc(id).delete();
  }

  Future<void> saveBanner(url) {
    return vendorbanner.add({
      'imageUrl': url,
      'sellerUid': user.uid,
    });
  }

  Future<void> deleteBanner({id}) {
    return vendorbanner.doc(id).delete();
  }

  Future<void> saveCoupon(
      {document, title, discountRate, expiry, details, active}) {
    if (document == null) {
      return coupons.doc(title).set({
        'title': title,
        'discountRate': discountRate,
        'Expiry': expiry,
        'details': details,
        'active': active,
        'sellerId': user.uid,
      });
    }
    return coupons.doc(title).update({
      'title': title,
      'discountRate': discountRate,
      'Expiry': expiry,
      'details': details,
      'active': active,
      'sellerId': user.uid,
    });
  }

  Future<DocumentSnapshot> getShopDetails() async {
    DocumentSnapshot doc = await vendors.doc(user.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<void> selectBoys({orderId, email, location, name, image, phone}) {
    var result = orders.doc(orderId).update({
      'deliveryBoy': {
        'email': email,
        'location': location,
        'name': name,
        'image': image,
        'phone': phone,
      }
    });
    return result;
  }
}

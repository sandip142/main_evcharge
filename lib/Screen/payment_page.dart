import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:main_evcharge/Screen/Stations_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PaymentPage({Key? key, required this.bookingData}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _startPayment();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Dispose the Razorpay instance
    super.dispose();
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_M5BGoCTvBT4zcT', // Replace with your Razorpay API key
      'amount': (widget.bookingData['amount'] * 100).toInt(), // In paise
      'name': "  ${widget.bookingData['stationName']}",
      'description': 'Station Booking Payment',
      'prefill': {
        'contact': widget.bookingData['mobileNumber'],
        'email': 'test@example.com',
      },
      'send_sms_hash': true,
      'retry': {'enabled': true, 'max_count': 2},
      'theme': {'color': '#3399cc'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      DocumentReference bookingRef = await FirebaseFirestore.instance
          .collection('bookings')
          .add(widget.bookingData);
      String bookingId = bookingRef.id; // Get the generated booking ID

      // Store the bookingId in the station's bookings array
      await FirebaseFirestore.instance
          .collection('stations')
          .doc(widget.bookingData['stationId'])
          .update({
        'isBook': true,
        'bookingIds': FieldValue.arrayUnion([bookingId]), // Add to the array
      });

      // Show success message
      Fluttertoast.showToast(
        msg: 'Payment Successful! Booking Confirmed.',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StationsScreen(), // also get latitude and lognitude and then send from here
        ),
      );
      // Navigate back to the previous screen
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error saving data: ${e.toString()}',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment Failed: ${response.message}',
      backgroundColor: Colors.red,
    );
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'External Wallet Selected');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Processing Payment')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

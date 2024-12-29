import 'package:flutter/material.dart';
import 'package:main_evcharge/Screen/ask_detail_form.dart';
import 'package:main_evcharge/services/Stand_firebase.dart';

class ChargingPoint extends StatefulWidget {
  const ChargingPoint({
    super.key,
    required this.mid,
    required this.sid,
    required this.totalCost,
    required this.stationName,
    //required this.uid,
  });
  final String mid;
  final String sid;
  final double totalCost;
  final String stationName;
  //final String uid;

  @override
  State<ChargingPoint> createState() => _ChargingPointState();
}

class _ChargingPointState extends State<ChargingPoint> {
  bool _isHovered = false;

   bool _isBusy = false; // Track the busy status

  @override
  void initState() {
    super.initState();
    _checkBusyStatus(); // Check the busy status on widget initialization
  }

  Future<void> _checkBusyStatus() async {
    final busyStatus = await checkPortStatus(widget.mid, widget.sid);
    setState(() {
      _isBusy = busyStatus;
    });
  }
 


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () async {   
         final isBusy = await checkPortStatus(widget.mid,widget.sid);
         if(!isBusy){
          print(!isBusy);  
          print(widget.sid);
          print(widget.mid);
          print(widget.stationName);
          print(widget.totalCost);
           Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BookingForm(
                        sid: widget.sid,
                        id: widget.mid,
                        ammount: widget.totalCost,
                        stationName: widget.stationName, 
                       // uid: '',
                      ),
                    ),
           );
         }else{
           ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Station Is Already Booked ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
         }

      
          print("Charging Point Button Tapped!");
        },
        onTapDown: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _isHovered = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isHovered ? 220 : 200,
          height: _isHovered ? 70 : 60,
          decoration: BoxDecoration(
            color:_isBusy? const Color.fromARGB(221, 55, 53, 53):Colors.blue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: _isHovered ? 15 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "Charging Point",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:main_evcharge/Utils.dart/ApiKeys.dart';
import 'package:main_evcharge/Utils.dart/const.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    required this.dlat,
    required this.dlong,
    required this.slat,
    required this.slong,
  });

  final double dlat;
  final double dlong;
  final double slat;
  final double slong;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _mapController = Completer();
  // static LatLng SourceLacation =
  //     LatLng(widget.sla,widget.slong);
  //static  LatLng destinationLacation = LatLng(widget.dlat,widget.dlong);

  List<LatLng> polylineCoordinate = [];

  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: google_api_key,
      request: PolylineRequest(
        origin: PointLatLng(LatLng(widget.slat,widget.slong).latitude, LatLng(widget.slat,widget.slong).longitude),
        destination: PointLatLng(
           LatLng(widget.dlat,widget.dlong).latitude,  LatLng(widget.dlat,widget.dlong).longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinate.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    } else {
      print("not fetch polyline error properly");
    }
    print(result.points);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPolyPoints();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   _mapController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Station Traker"),
        centerTitle: true,
      ),
      body:
          // currentLocation == null
          //     ? const Center(
          //         child: Text("loading"),
          //       ):
          GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.slat,widget.slong),
          zoom: 13.5,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("routes"),
            points: polylineCoordinate,
            color: const Color.fromARGB(255, 17, 75, 123),
            //width: 6
          ),
        },
        markers: {
          Marker(
            markerId: MarkerId("source"),
            position: LatLng(widget.slat,widget.slong),
          ),
           Marker(
              //to remove const here in future
              markerId: MarkerId("Destination"),
              position:  LatLng(widget.dlat,widget.dlong)),
        },
      ),
    );
  }
}

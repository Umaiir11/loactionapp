import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  GoogleMapsScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  Set<Marker> l_Markers = {};
  GoogleMapController? l_GoogleMapController;
  static const CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 14);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Location")),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: l_Markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          print("Map Created");
          l_GoogleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position l_Position = await getCurrentLocation();
          l_GoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(l_Position.latitude, l_Position.longitude), zoom: 14)));

          l_Markers.clear();
          l_Markers
              .add(Marker(markerId: MarkerId('currentlocation'), position: LatLng(l_Position.latitude, l_Position.longitude)));
          setState(() {

          });
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Location_screen extends StatefulWidget {
  const Location_screen({Key? key}) : super(key: key);

  @override

  State<Location_screen> createState() => _Location_screenState();
}

class _Location_screenState extends State<Location_screen> {
  @override
   Position? currentPosition;
   String? currentAddress;

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String address =
        '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    setState(() {
      currentPosition = position;
      currentAddress = address;
    });
  }
  @override
  void initState() {
    super.initState();
    FncPermissions();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Screen'),
      ),
      body: currentPosition == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Latitude: ${currentPosition!.latitude}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            'Longitude: ${currentPosition!.longitude}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            'Address: $currentAddress',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }



  Future<void> FncPermissions() async {
    PermissionStatus l_mediaPermission = await Permission.location.request();

    if (l_mediaPermission == PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Permission granted"),
        duration: Duration(milliseconds: 900),
      ));
    } else if (l_mediaPermission == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("This permission is recommended."),
        duration: Duration(milliseconds: 900),
      ));
    } else if (l_mediaPermission == PermissionStatus.permanentlyDenied) {
      bool isShown = await Permission.location.shouldShowRequestRationale;
      if (isShown) {
        // Show a dialog explaining why the permission is needed
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Location Permission Required"),
            content: Text("This app needs to access your location to function properly."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("OK"),
              ),
            ],
          ),
        ).then((value) async {
          if (value == true) {
            // Request permission again
            FncPermissions();
          }
        });
      } else {
        // Prompt the user to go to the app settings and grant the permission manually
        openAppSettings();
      }
    }
  }


}

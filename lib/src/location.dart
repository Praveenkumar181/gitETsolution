import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:particeproject/src/maping.dart';
class addlocationscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Expanded(
            child: MapView(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _addCurrentLocation(context),
              child: Text('Add Current Location'),
            ),
          ),
        ],
      ),
    );
  }

  void _addCurrentLocation(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      await FirebaseFirestore.instance.collection('locations').add({
        'location':
        GeoPoint(currentLocation.latitude, currentLocation.longitude),
        'timestamp': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location added successfully'),
      ));
    } catch (e) {
      print('Error adding location: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add location'),
      ));
    }
  }
}
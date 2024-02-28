
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:particeproject/main.dart';
import 'package:particeproject/src/location.dart';
import 'package:particeproject/src/loginscreen.dart';

class LocationScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  LocationScreen({required this.latitude, required this.longitude});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late List<Map<String, double>> _coordinates;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _coordinates = [{'latitude': widget.latitude, 'longitude': widget.longitude}];
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 15), (timer) {
      // Simulated update of latitude and longitude
      setState(() {
        _coordinates.add({
          'latitude': _coordinates.last['latitude']! + 0.001,
          'longitude': _coordinates.last['longitude']! + 0.001,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: ListView.builder(
        itemCount: _coordinates.length,
        itemBuilder: (context, index) {
          final coordinate = _coordinates[index];
          return Column(
            children: [
              
              GestureDetector(
    onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addlocationscreen()
                  ),
                );
              },
                child: ListTile(
                  title: Text('Latitude: ${coordinate['latitude']}, Longitude: ${coordinate['longitude']}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapScreen({required this.latitude, required this.longitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  List<LatLng> _locationHistory = []; // Store location history data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('Location'),
                position: LatLng(widget.latitude, widget.longitude),
              ),
            },
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _playbackLocationHistory,
              child: Icon(Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playbackLocationHistory() async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference locations = firestore.collection('locationhistory');

    try {
      QuerySnapshot querySnapshot = await locations.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;

      List<LatLng> locationHistory = [];

      documents.forEach((DocumentSnapshot document) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?; // Explicit cast
        if (data != null &&
            data.containsKey('latitude') &&
            data.containsKey('longitude') &&
            data['latitude'] is double && // Check if latitude is double
            data['longitude'] is double) { // Check if longitude is double
          double latitude = data['latitude'] as double;
          double longitude = data['longitude'] as double;
          locationHistory.add(LatLng(latitude, longitude));
        }
      });

      setState(() {
        _locationHistory = locationHistory;
      });

      // Start animating the location history
      _animateLocationHistory();
    } catch (e) {
      print('Error fetching location history: $e');
    }
  }





  void _animateLocationHistory() {
    if (_locationHistory.isNotEmpty && _mapController != null) {
      for (int i = 0; i < _locationHistory.length; i++) {
        Future.delayed(Duration(seconds: i), () {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_locationHistory[i]),
          );
        });
      }
    }
  }
}

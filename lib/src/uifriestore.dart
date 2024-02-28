
import 'dart:async';
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
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
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


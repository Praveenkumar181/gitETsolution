import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _controller;
  List<LatLng> _locations = []; // Location data fetched from Firestore

  @override
  void initState() {
    super.initState();
    _fetchLocations(); // Fetch location data when the map view is initialized
  }

  Future<void> _fetchLocations() async {
    FirebaseFirestore.instance
        .collection('locations')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _locations = snapshot.docs.map((doc) {
          GeoPoint geoPoint = doc.data()['location'];
          return LatLng(geoPoint.latitude, geoPoint.longitude);
        }).toList();
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });

    if (_locations.isNotEmpty) {
      LatLng firstLocation = _locations.first;
      _controller.animateCamera(CameraUpdate.newLatLngZoom(firstLocation, 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,

              initialCameraPosition: _locations.isNotEmpty
                  ? CameraPosition(
                      target: _locations.first,
                      zoom: 12, // Adjust the zoom level as needed
                    )
                  : _locations.first != null
                      ? CameraPosition(
                          target: LatLng(_locations.first! as double,
                              _locations.first as double),
                          zoom: 12,
                        )
                      : CameraPosition(
                          target: LatLng(0,
                              0), // Default to (0, 0) if no locations are available
                          zoom: 2,
                        ),

              markers: _locations
                  .map((location) => Marker(
                        markerId: MarkerId(location.toString()),
                        position: location,
                      ))
                  .toSet(),
              myLocationEnabled: true, // Enable the my location button
              myLocationButtonEnabled: true, // Enable the my location button
            ),
          ],
        ),
      ),
    );
  }
}

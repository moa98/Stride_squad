import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stridesquad1/track.dart';
import 'package:stridesquad1/user.dart';

// ignore: must_be_immutable
class RouteMapScreen extends StatefulWidget {
  LatLng cityCenter;
  List<LatLng> roadPoints;
  Track track;

  RouteMapScreen(
      {required this.cityCenter,
      required this.roadPoints,
      required this.track});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  late GoogleMapController mapController;

  // Coordinates for Tel Aviv and a specific road
  //final LatLng _cityCenter = LatLng(32.0853, 34.7818); // Tel Aviv Center

  // final List<LatLng> _roadPoints = [
  //   LatLng(32.0809, 34.7806),
  //   LatLng(32.0812, 34.7815),
  //   LatLng(32.0820, 34.7827),
  //   LatLng(32.0832, 34.7841),
  // ];

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createPolyline();
    _addMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _createPolyline() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('roadPolyline'),
      points: widget.roadPoints,
      color: Colors.blue,
      width: 5,
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  void _addMarkers() {
    // Add a marker at the start of the road
    Marker startMarker = Marker(
      markerId: const MarkerId('start'),
      position: widget.roadPoints.first,
      infoWindow: const InfoWindow(
        title: 'Start of Road',
        snippet: 'Specific road in Tel Aviv',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    // Add a marker at the end of the road
    Marker endMarker = Marker(
      markerId: const MarkerId('end'),
      position: widget.roadPoints.last,
      infoWindow: const InfoWindow(
        title: 'End of Road',
        snippet: 'Specific road in Tel Aviv',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(startMarker);
      _markers.add(endMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RouteMap'),
        elevation: 0,
      ),
      body: Column(
        children: [
          UserInfoSection(
            track: widget.track,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: widget.cityCenter,
                    zoom: 14,
                  ),
                  polylines: _polylines, // Add polylines to the map
                  markers: _markers, // Add markers to the map
                ),
              ),
            ),
          ),
          RouteStatsSection(
            track: widget.track,
          ),
        ],
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  UserInfoSection({required this.track});
  Track track;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage:
                AssetImage('assets/female.jpg'), // Add your image asset here
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  maxLines: 1,
                  track.Name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Running at Technion 1',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                'Tuesday 16 | 18:26am',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RouteStatsSection extends StatelessWidget {
  RouteStatsSection({required this.track});
  Track track;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Running time',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            '00:${track.time}:00',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(icon: Icons.directions_run, value: track.distance),
            ],
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;

  StatItem({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

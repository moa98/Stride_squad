import 'package:flutter/material.dart';


class RouteMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RouteMap'),
        elevation: 0,
      ),
      body: Column(
        children: [
          UserInfoSection(),
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.grey[200], // Placeholder for the map
                  child: Center(child: Text('Map Placeholder')),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.gps_fixed, color: Colors.green),
                        SizedBox(height: 4),
                        Text('GPS'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          RouteStatsSection(),
        ],
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/female.jpg'), // Add your image asset here
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Route',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Running at Brisbane Riverwalk',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                'Friday 23 | 10:00am',
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
            '01:09:44',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(icon: Icons.directions_run, value: '10.9 km'),
              StatItem(icon: Icons.local_fire_department, value: '539 kcal'),
              StatItem(icon: Icons.flash_on, value: '12.3 km/hr'),
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
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

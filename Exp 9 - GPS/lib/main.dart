import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.fredoka().fontFamily,
        textTheme: GoogleFonts.fredokaTextTheme(),
        iconTheme: IconThemeData(color: Colors.white), // optional
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.brown.shade500,
        ),
        useMaterial3: true,
      ),

    );
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _locationMessage = "Fetching location...";
  Position? _position;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() {
      _locationMessage = "Fetching location...";
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _position = position;
        _locationMessage =
        "Latitude: ${position.latitude}\n"
            "Longitude: ${position.longitude}\n"
            // "Accuracy: ${position.accuracy}m\n"
            "Time: ${position.timestamp}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get location: $e";
      });
    }
  }

  void _openInGoogleMaps() {
    if (_position != null) {
      final lat = _position!.latitude;
      final lon = _position!.longitude;
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
      launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "GPS Location App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // color: Colors.white, // Optional: makes text pop on dark bg
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.brown.shade900,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "bg.jpeg", // Make sure the image is in assets folder
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _locationMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      if (_position != null)
                        ElevatedButton.icon(
                          onPressed: _openInGoogleMaps,
                          // icon: Icon(Icons.map),
                          icon: Icon(
                            CupertinoIcons.pin,
                            color: Colors.white,
                          ),
                          label: Text("Open in Google Maps"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown.shade500,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        child: Icon(
          CupertinoIcons.refresh,
          color: Colors.white,
        ),
        tooltip: 'Refresh Location',
      ),
    );
  }
}

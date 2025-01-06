import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/helper/openaiapikey.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/theme/apptheme.dart';
import 'package:url_launcher/url_launcher.dart';

class Destination extends StatefulWidget {
  const Destination({super.key});

  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  final String _apiKey = "ba641f122f3d412b97bd65fb149249b3";
  final double _latitude = locactionData!.latitude!; // Example: San Francisco
  final double _longitude = locactionData!.longitude!;
  final double _radius = 1000; // Radius in meters

  List<dynamic> _places = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    final url =
        "https://api.geoapify.com/v2/places?categories=commercial,highway.service,catering.restaurant,commercial.supermarket,commercial.gas,catering,education,education.school,education.college,education.university,healthcare.hospital,healthcare.dentist,office,national_park,rental,service,service.beauty,tourism,tourism.attraction&filter=circle:$_longitude,$_latitude,$_radius&limit=20&apiKey=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _places = data['features'];
          _loading = false;
        });
      } else {
        print("Failed to fetch places: ${response.body}");
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  void showPlaceDetailsDialog(double lat, double lng) {
    final Uri _url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$lat, $lng");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "View map",
            style: appTheme.textTheme.headlineMedium,
          ),
          content: Container(
            width: MediaQuery.of(context).size.width - 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.map),
                    Gap(4),
                    Text("You will direct to Google map"),
                  ],
                ),
                Gap(12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _launchUrl(_url),
                  child: Text("Okay"),
                ),
                Gap(4),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Destinations",
              style: appTheme.textTheme.headlineLarge,
            ),
            Gap(12),
            _loading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : _places.isEmpty
                    ? Center(child: Text("No places found."))
                    : placesList(),
          ],
        ),
      ),
    );
  }

  Expanded placesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final place = _places[index]['properties'];
          final coordinates = _places[index]['geometry']['coordinates'];
          final longitude = coordinates[0];
          final latitude = coordinates[1];
          return Padding(
            padding: EdgeInsets.only(
              bottom: 12,
            ),
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () => showPlaceDetailsDialog(latitude, longitude),
                  contentPadding: EdgeInsets.all(0),
                  leading: Icon(
                    Icons.location_on,
                    color: appTheme.colorScheme.error,
                  ),
                  title: Text(
                    place['name'] ?? 'Unnamed',
                    style: appTheme.textTheme.headlineMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place['formatted'] ?? 'No address'),
                      Gap(4),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: appTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          place['categories']?.first?.split('.')?.last ?? '',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

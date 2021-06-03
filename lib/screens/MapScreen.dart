import 'package:flutter/material.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _latitude = 0;
  double _longitude = 0;
  bool _isGettingLocation = true;
  GoogleMapController? _mapController;
  TextEditingController? _controllerText;
  FocusNode? _focusNode;
  Set<Marker> _markers = Set();

  void getLocation() async {
    Location _location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    try {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {}
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {}
      }

      _locationData = await _location.getLocation();
      if (_locationData.latitude != null && _locationData.longitude != null) {
        setState(() {
          _isGettingLocation = false;
          _latitude = _locationData.latitude!;
          _longitude = _locationData.longitude!;
          _markers.add(
            Marker(
              markerId: MarkerId('Position'),
              onTap: () {},
              position:
                  LatLng(_locationData.latitude!, _locationData.longitude!),
            ),
          );
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isGettingLocation
          ? CircularProgressIndicator()
          : Stack(
              children: [
                GoogleMap(
                  onTap: (latLng) {
                    if (_focusNode!.hasFocus) {
                      _focusNode!.unfocus();
                    }
                    print(latLng);
                  },
                  markers: _markers,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_latitude, _longitude),
                    zoom: 18,
                  ),
                  onMapCreated: (controller) {
                    controller.setMapStyle(MapStyle.mapStyle);
                    _mapController = controller;
                  },
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [
                        Card(
                          child: TextField(
                            autofocus: false,
                            focusNode: _focusNode,
                            controller: _controllerText,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.search,
                              ),
                              hintText: "Search for location",
                              contentPadding: EdgeInsets.all(16),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.my_location,
          ),
          backgroundColor: Colors.blue,
          onPressed: () {
            _mapController!
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(_latitude, _longitude),
              zoom: 18,
            )));
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode!.dispose();
  }
}

class MapStyle {
  static String mapStyle = '''
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
  ''';
}

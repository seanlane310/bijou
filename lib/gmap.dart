import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bijou/businesspage.dart';

class GMap extends StatefulWidget {
  var bus_dis;

  GMap({Key key, @required this.bus_dis}) : super(key: key);

  @override
  _GMapState createState() => _GMapState(bus_dis);
}

class _GMapState extends State<GMap> {
  bool mapToggle = false;
  var currentLocation;
  var businesses = [];
  int marker_id_count = 0;
  var bus_dis;
  _GMapState(this.bus_dis);

  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        populateBusinesses();
      });
    });
  }

  populateBusinesses() async {
    businesses = [];
    FirebaseFirestore.instance.collection('Businesses').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          businesses.add(docs.docs[i].data());
          initMarker(docs.docs[i].data(), bus_dis[i]);
        }
      }
    });
  }

  initMarker(business, dist) async {
    _markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        markerId: MarkerId(marker_id_count.toString()),
        position: LatLng(
            business['Location'].latitude, business['Location'].longitude),
        infoWindow: InfoWindow(
            title: business['Name'],
            snippet: business['Description'],
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => businesspage(
                        business: business,
                        bus_dis: dist,
                      )));
            })));
    ++marker_id_count;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.setMapStyle(Utils.mapStyle);
    setState(() {
      _markers.add(Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          markerId: MarkerId(marker_id_count.toString()),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(
            title: "Current Location",
            snippet: "You are here",
          )));
    });
    ++marker_id_count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                    height: MediaQuery.of(context).size.height - 80.0,
                    width: double.infinity,
                    child: mapToggle
                        ? GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation.latitude,
                                  currentLocation.longitude),
                              zoom: 13,
                            ),
                            markers: _markers,
                            myLocationButtonEnabled: true,
                          )
                        : Center(
                            child: Text(
                            'Loading...',
                            style: TextStyle(fontSize: 20.0),
                          )))
              ],
            )
          ],
        ));
  }
}

class Utils {
  static String mapStyle = '''
[
  {
    "featureType": "poi",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.attraction",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.government",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.medical",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.place_of_worship",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.school",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]
  ''';
}

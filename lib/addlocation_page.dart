import 'package:app_project/farm_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addlocation extends StatelessWidget {
  const addlocation({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          home: Addlocation_page(),
        );
      },
    );
  }
}

Set<Marker> _markers = {};
var getlatlng;

Future<void> updateFarmLocation(String newLocation) async {
  try {
    // Get a reference to the Firestore document
    DocumentReference farmRef = FirebaseFirestore.instance
        .collection('Farm')
        .doc(getdocId.docid.toString());

    // Update the 'location' field of the document
    await farmRef.update({'Location': newLocation});
    print('Location updated successfully');
  } catch (e) {
    print('Error updating location: $e');
  }
}

class Addlocation_page extends StatefulWidget {
  const Addlocation_page({super.key});

  @override
  State<Addlocation_page> createState() => _Addlocation_pageState();
}

class _Addlocation_pageState extends State<Addlocation_page> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.3082772, 98.3790378),
    zoom: 8.88,
  );

  @override
      void initState() {
      super.initState();
      _markers = {};
    }
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: getlatlng != null
          ? Padding(
              padding: EdgeInsets.only(bottom: 0.08.sw),
              child: FloatingActionButton(
                backgroundColor: HexColor("#067D68"),
                onPressed: () => setState(() {
                   updateFarmLocation(getlatlng.toString());
                    Navigator.pop(context);
                }),
                tooltip: 'Add Task',
                child: const Icon(Icons.done),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: HexColor("#067D68"), //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Wrap(
        children: [
          Container(
            child: GoogleMap(
              markers: _markers,
              onTap: (LatLng latLng) {
                print(latLng);
                setState(() {
                  getlatlng = latLng;
                  _markers.add(Marker(
                    markerId: MarkerId('new'),
                    position: latLng,
                    draggable: true,
                    onDragEnd: (LatLng position) {
                      print('Marker dragged to $position');
                    },
                  ));
                });
              },
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            height: 1.sh,
          )
        ],
      ),
    );
  }
}

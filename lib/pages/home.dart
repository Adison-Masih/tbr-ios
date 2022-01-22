import 'package:flutter/material.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/widgets/deal_list.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<dynamic> getDeals() async {
    String city = "";
    String state = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('city') && prefs.containsKey('state')) {
      setState(() {
        city = prefs.getString('city');
        state = prefs.getString('state');
      });
    }

    var res = await callApi(
      url: getApiUrl(method: "deals"),
      method: HttpMethods.POST,
      postParams: {'city': city, 'state': state},
      decode: true,
    );
    // print(res);

    // print(res);

    DealModel.deals = List.from(res)
        .map<Deal>(
          (deal) => Deal.fromMap(deal),
        )
        .toList();
    setState(() {});
  }

  Future<dynamic> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(
      prefs.getString('city'),
    );

    print(
      prefs.getString('state'),
    );
    if (!prefs.containsKey('city') && !prefs.containsKey('state')) {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();

      print(_locationData.latitude);
      print(_locationData.longitude);

      var res = await callApi(
        url:
            "http://open.mapquestapi.com/geocoding/v1/reverse?key=71jDuvGKuCjy8k8IdAg8ccn9Zj1wE2BI&location=${_locationData.latitude},${_locationData.longitude}&includeRoadMetadata=true&includeNearestIntersection=true",
      );

      String city = res["results"][0]["locations"][0]["adminArea5"].toString();
      String state = res["results"][0]["locations"][0]["adminArea3"].toString();

      prefs.setString('city', city);
      prefs.setString('state', state);

      setState(() {
        city = prefs.getString('city');
        state = prefs.getString('state');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDeals();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        title: Const.name.text.make(),
      ),
      body: Container(
        width: _mediaQuery.width,
        height: _mediaQuery.height,
        padding: Vx.m16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "Top Deals"
                .text
                .headline4(context)
                .color(context.theme.accentColor)
                .make()
                .pOnly(bottom: 20.0),
            if (DealModel.deals.isNotEmpty)
              DealList(
                searchDeals: false,
              ).expand()
            else
              Center(
                child: CircularProgressIndicator(
                  color: context.theme.accentColor,
                ),
              ),
          ],
        ),
      ),
      drawer: const TopNav(
        active: 0,
      ),
    );
  }
}

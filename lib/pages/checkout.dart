import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/pages/single_deal.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/utils/routes.dart';
import 'package:the_beauty_rox/widgets/go_back.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';

class Checkout extends StatefulWidget {
  var deal;
  Checkout({
    Key key,
    @required this.deal,
  }) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState(deal: deal);
}

class _CheckoutState extends State<Checkout> {
  var deal;
  _CheckoutState({
    @required this.deal,
  });

  List<String> cities = [];
  List<String> states = [];
  List<String> categories = [];

  String _selectedCity = "";
  String _selectedState = "";

  bool isLoading = false;

  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  Future<dynamic> orderDeal() async {
    String address = addressController.text.toString();
    String landmark = addressController.text.toString();
    String pinCode = addressController.text.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id').toString();

    var res = await callApi(
      url: getApiUrl(method: 'order'),
      method: HttpMethods.POST,
      postParams: {
        'deal': deal.id,
        'address': address,
        'landmark': landmark,
        'pin_code': pinCode,
        'state': _selectedState,
        'city': _selectedCity,
        'user_id': userId.toString()
      },
      decode: true,
    );

    print(res.toString());

    if (res["status"] == "200") {
      alertMsg(
        context: context,
        title: "Order Successfull!",
        text:
            "Your Order Has Been Placed. Please Pay The Deal Price At The Salon At Time Of Availing.",
        callback: () {
          print("callback success");
          Navigator.of(context).pushNamed(Routes.ordersRoute);
        },
      );
    } else {
      alertMsg(
        context: context,
        title: "Error!",
        text: res["message"],
        callback: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<dynamic> getCities() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCity = prefs.getString('city') == 'Zirkapur'
          ? 'Zirakpur'
          : prefs.getString('city');
      _selectedState = prefs.getString('state');
    });
    var res = await callApi(
      url: getApiUrl(method: 'cities'),
      method: HttpMethods.GET,
    );

    print("cities:\n");
    print(res.toString());

    setState(() {
      cities = List.from(res);
      isLoading = false;
    });
  }

  Future<dynamic> getStates() async {
    isLoading = true;
    var res = await callApi(
      url: getApiUrl(method: 'states'),
      method: HttpMethods.GET,
    );

    print("states:\n");
    print(res.toString());

    setState(() {
      states = List.from(res);
      isLoading = false;
    });
  }

  Future<dynamic> getCategories() async {
    isLoading = true;
    var res = await callApi(
      url: getApiUrl(method: 'categories'),
      method: HttpMethods.GET,
    );

    print("categories:\n");
    print(res.toString());

    setState(() {
      categories = List.from(res);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCities();
    getStates();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GoBack(),
      backgroundColor: context.theme.canvasColor,
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        title: (Const.name).text.make(),
      ),
      drawer: const TopNav(active: 99),
      body: Container(
        height: context.screenHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Form(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SingleDeal(deal: deal);
                              },
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Text(
                              "Purchasing",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${deal.title}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.theme.accentColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.heightBox,
                      DropdownSearch<String>(
                        selectedItem: _selectedCity,
                        mode: Mode.BOTTOM_SHEET,
                        showSearchBox: true,
                        showSelectedItem: true,
                        popupTitle: Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, bottom: 7, right: 15.0, left: 15.0),
                          child: Text(
                            "Select City",
                            style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.none,
                              color: context.theme.accentColor,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          ),
                        ),
                        items: cities,
                        label: "City",
                        onChanged: (val) {
                          setState(() {
                            _selectedCity = val;
                            print(_selectedCity);
                          });
                        },
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                        selectedItem: _selectedState,
                        popupTitle: Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, bottom: 7, right: 15.0, left: 15.0),
                          child: Text(
                            "Select State",
                            style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.none,
                              color: context.theme.accentColor,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          ),
                        ),
                        mode: Mode.BOTTOM_SHEET,
                        showSearchBox: true,
                        showSelectedItem: true,
                        items: states,
                        label: "State",
                        onChanged: (val) {
                          setState(() {
                            _selectedState = val;
                            print(_selectedState);
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // ignore: avoid_unnecessary_containers
                      TextFormField(
                        controller: landmarkController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.primaryColor, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          ),
                          label: const Text("Your Address"),
                          hintText: "Enter Your Address",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field Cannot Be Empty!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.primaryColor, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          ),
                          label: const Text("Your Landmark"),
                          hintText: "Enter Your Place's Landmark",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field Cannot Be Empty!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: pinCodeController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.primaryColor, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          ),
                          label: const Text("Enter Your Zip/Pin Code"),
                          hintText: "Pin Code",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Field Cannot Be Empty!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: ElevatedButton(
                          child: const Text("Confirm Order"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              context.theme.buttonColor,
                            ),
                          ),
                          onPressed: orderDeal,
                        ).wFull(context).h(50),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

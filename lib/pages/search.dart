import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/pages/search_results.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/widgets/deal_list.dart';
import 'package:the_beauty_rox/widgets/go_back.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> sectors = [
    'No Sector',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60',
    '61',
    '62',
    '63',
    '64',
    '65',
    '66',
    '67',
    '68',
    '69',
    '70',
    '71',
    '72',
    '73',
    '74',
    '75',
    '76',
    '77',
    '78',
    '79',
    '80',
    '81',
    '82',
    '83',
    '84',
    '85',
    '86',
    '87',
    '88',
    '89',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
    '98',
    '99',
    '100',
    '101',
    '102',
    '103',
    '104',
    '105',
    '106',
    '107',
    '108',
    '109',
    '110',
    '111',
    '112',
    '113',
    '114',
    '115',
    '116',
    '117',
    '118',
    '119',
    '120',
    '121',
    '122',
    '123',
    '124',
    '125',
    '126',
    '127',
    '128',
    '129',
    '130',
  ];

  List<String> cities = [];
  List<String> states = [];
  List<String> categories = [];

  String _selectedCity = "";
  String _selectedState = "";
  String _selectedCategory = "";
  String _selectedSector = "";

  bool isLoading = false;

  Future<dynamic> getDeals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCity = prefs.getString('city') == 'Zirkapur'
          ? 'Zirakpur'
          : prefs.getString('city');
      _selectedState = prefs.getString('state');
    });
    var res = await callApi(
      url: getApiUrl(method: "deals"),
      method: HttpMethods.POST,
    );

    // print(res);

    DealModel.deals = List.from(res)
        .map<Deal>(
          (deal) => Deal.fromMap(deal),
        )
        .toList();
    setState(() {});
  }

  Future<dynamic> getCities() async {
    isLoading = true;
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

  // Controllers
  TextEditingController fromPriceController = TextEditingController();
  TextEditingController toPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDeals();
    getCities();
    getStates();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: GoBack(),
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        title: Const.name.text.make(),
      ),
      drawer: const TopNav(
        active: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _mediaQuery.width,
          height: _mediaQuery.height,
          padding: Vx.m16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "Search Deals".text.headline4(context).make().pOnly(
                    bottom: 10,
                  ),
              "Filter Deals According To You".text.make().pOnly(bottom: 25),
              !isLoading
                  ? Form(
                      child: Column(
                        children: [
                          DropdownSearch<String>(
                            selectedItem: _selectedCity,
                            mode: Mode.BOTTOM_SHEET,
                            showSearchBox: true,
                            showSelectedItem: true,
                            popupTitle: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 7,
                                  right: 15.0,
                                  left: 15.0),
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
                            mode: Mode.BOTTOM_SHEET,
                            showSearchBox: true,
                            showSelectedItem: true,
                            popupTitle: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 7,
                                  right: 15.0,
                                  left: 15.0),
                              child: Text(
                                "Select Sector",
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.none,
                                  color: context.theme.accentColor,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                ),
                              ),
                            ),
                            items: sectors,
                            label: "Sector",
                            onChanged: (val) {
                              setState(() {
                                _selectedSector = val;
                                print(_selectedSector);
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
                                  top: 15.0,
                                  bottom: 7,
                                  right: 15.0,
                                  left: 15.0),
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
                          DropdownSearch<String>(
                            popupTitle: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 7,
                                  right: 15.0,
                                  left: 15.0),
                              child: Text(
                                "Select Category",
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
                            items: categories,
                            label: "Category",
                            onChanged: (val) {
                              setState(() {
                                _selectedCategory = val;
                                print(_selectedCategory);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // ignore: avoid_unnecessary_containers
                          TextFormField(
                            controller: fromPriceController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: context.theme.primaryColor,
                                    width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              label: const Text("Price From"),
                              hintText: "Price From",
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
                            controller: toPriceController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: context.theme.primaryColor,
                                    width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              label: const Text("Price To"),
                              hintText: "Price To",
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
                              child: const Text("Search Deals"),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  context.theme.buttonColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) {
                                      return SearchResults(filters: {
                                        'city': _selectedCity,
                                        'category': _selectedCategory,
                                        'state': _selectedState,
                                        'sector': _selectedSector == 'No Sector'
                                            ? '0'
                                            : _selectedSector,
                                        'min': fromPriceController.text,
                                        'max': toPriceController.text
                                      });
                                    },
                                  ),
                                );
                              },
                            ).wFull(context).h(50),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: context.theme.accentColor,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

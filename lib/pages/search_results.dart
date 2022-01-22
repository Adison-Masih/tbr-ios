import 'package:flutter/material.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/widgets/deal_list.dart';
import 'package:the_beauty_rox/widgets/go_back.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchResults extends StatefulWidget {
  Map<String, String> filters;
  SearchResults({Key key, @required this.filters}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SearchResultsState createState() => _SearchResultsState(filters: filters);
}

class _SearchResultsState extends State<SearchResults> {
  Map<String, String> filters;
  _SearchResultsState({@required this.filters});

  bool isLoading = true;
  Future<dynamic> getDeals() async {
    setState(() {
      isLoading = true;
    });
    var res = await callApi(
      url: getApiUrl(method: "search"),
      method: HttpMethods.POST,
      // postParams: {
      //   'state': 'Punjab',
      //   'city': 'Zirakpur',
      //   'category': 'Special Packages 999',
      //   'sector': '0',
      //   'min': '299',
      //   'max': '999'
      // },
      postParams: filters,
      decode: true,
    );
    print(res.toString());
    DealModel.searchDeals = List.from(res)
        .map<Deal>(
          (deal) => Deal.fromMap(deal),
        )
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDeals();
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
      body: Container(
        width: _mediaQuery.width,
        height: _mediaQuery.height,
        padding: Vx.m16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "Search Results"
                .text
                .headline4(context)
                .color(context.theme.accentColor)
                .make()
                .pOnly(bottom: 20.0),
            if (DealModel.searchDeals.isNotEmpty)
              Expanded(
                  child: DealList(
                searchDeals: true,
              ))
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
        active: 99,
      ),
    );
  }
}
